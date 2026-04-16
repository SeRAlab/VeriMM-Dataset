#!/usr/bin/env python3
"""
Testbench Generation Pipeline with Coverage-Driven Iteration
=============================================================
A modular pipeline for automated Verilog testbench generation using LLM with iterative coverage improvement.

Pipeline Steps:
1. Analyze RTL design and generate testbench template
   1.1 Analyze RTL using analyze_rtl.py
   1.2 Generate testbench template with proper output ordering
3. Use LLM to generate initial testcases based on circuit specification
7. Aggregate initial testbench with generated testcases
8. Generate coverage gap report and use LLM to generate natural language testcases to cover gaps
9. Convert natural language testcases to Verilog testcases
10. Aggregate all testcases (from Stage 3 and Stage 9) into final testbench

Usage:
    python tb_pipeline.py <verilog_file> <specification_file> [options]

Features:
- Iterative coverage-driven testcase generation
- Natural language testcase specification for coverage gaps
- Automated aggregation of multiple testcase sets
- Adds #1; before each check_outputs() in generated testcases
"""

import os
import sys
import json
import subprocess
from pathlib import Path
from typing import Dict, Optional
from openai import OpenAI
import re

# Import the generator modules
import template_generation as tb_gen

def extract_verilog_code(text):
    pattern = r'```verilog\s*\n(.*?)\n```'
    match = re.search(pattern, text, re.DOTALL)
    if match:
        return match.group(1).strip()
    return ""

def remove_verilog_comments(verilog_code):
    # First, remove multi-line comments (/* ... */), allowing . to match newlines
    verilog_code = re.sub(r'/\*.*?\*/', '', verilog_code, flags=re.DOTALL)
    
    # Then, remove single-line comments (// ... to end of line)
    # Split into lines to handle properly
    lines = verilog_code.splitlines()
    cleaned_lines = []
    for line in lines:
        # Remove everything from // to end of line
        cleaned_line = re.sub(r'//.*', '', line).rstrip()
        cleaned_lines.append(cleaned_line)
    
    return '\n'.join(cleaned_lines)


# ============================================================================
# Configuration
# ============================================================================

class PipelineConfig:
    """Configuration for the pipeline."""

    # OpenAI API Configuration
    API_BASE_URL = "https://api.openai.com/v1"
    API_KEY = "your-api-key-here"
    MODEL="gemini-3-flash-preview"
    LLM_PROVIDER = "openai"


    # Output directory for intermediate files
    OUTPUT_DIR = "pipeline_output"

    # Prompts (loaded from prompt.txt by default)
    PROMPT_TESTCASE = (
        "I will give you a circuit specification and a testbench template, "
        "you need to understand the function of this circuit first, then give me "
        "some testcases to check the function of this circuit, if it's a sequential "
        "circuit, each testcases should begin with reset and end with output check. Here's specification:\"{spec}\", "
        "here's testbench template:\"{template}\"."
        "only check output at the end of each testcase. "
        " IMPORTANT: Name each testcase task using zero-padded numbers like: testcase001, testcase002, testcase003, etc. "
        "This ensures proper ordering when calling the testcases."
        " You should put all testcases between"
        "```verilog and ```."
    )


    PROMPT_TESTBENCH_AGGREGATION = (
        "i will give you a verilog testbench template and"
        " multiple verilog testcases, you need to aggregate"
        " all the testcases into the final verilog testbench. "
        "Here's verilog testbench template:\"{template}\","
        " here's multiple verilog testcases:\"{testcases}\"."
        " You should put all testcases between"
        "```verilog and ```."
    )

    PROMPT_COVERAGE_GAP = (
        "I will give you three things: 1) a coverage gap report, 2) the DUT code, "
        "and 3) the circuit specification. You need to analyze the coverage gaps "
        "and generate testcases in natural language to cover these gaps. "
        "IMPORTANT: The testcases should only be about input ports, NOT internal signals. "
        "Each testcase should be on one line. Here's the coverage gap report:\"{gap_report}\", "
        "here's the DUT code:\"{dut_code}\", here's the specification:\"{spec}\". "
        "Please provide one testcase per line in natural language describing what inputs to apply."
    )

    PROMPT_TESTCASE_FROM_GAPS = (
        "I will give you: 1) a circuit specification, 2) a testbench template, "
        "and 3) natural language testcases. You need to understand the function of this circuit first, "
        "then convert the natural language testcases into Verilog testcases. "
        "If it's a sequential circuit, each testcase should begin with reset and end with output check. "
        "Here's the specification:\"{spec}\", here's the testbench template:\"{template}\", "
        "here's the natural language testcases:\"{nl_testcases}\". "
        "Only check output at the end of each testcase. "
        "IMPORTANT: Name each testcase task using zero-padded numbers starting from {start_num}: testcase{start_num:03d}, testcase{next_num:03d}, etc. "
        "This ensures proper ordering when calling the testcases. "
        "You should put all testcases between ```verilog and ```."
    )   


# ============================================================================
# LLM Interface
# ============================================================================

class OpenaiClient:
    """Wrapper for OpenAI API calls."""

    def __init__(self, config: PipelineConfig):
        self.client = OpenAI(
            base_url=config.API_BASE_URL,
            api_key=config.API_KEY
        )
        self.model = config.MODEL

    def ask(self, prompt: str, system_message: str = "You are a helpful assistant specialized in Verilog testbench generation.") -> str:
        """Send a prompt to the LLM and get response."""
        try:
            print(f"[LLM] Sending request to {self.model}...")
            response = self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {"role": "system", "content": system_message},
                    {"role": "user", "content": prompt}
                ]
            )
            result = response.choices[0].message.content.strip()
            print(f"[LLM] Response received ({len(result)} chars)")
            return result
        except Exception as e:
            print(f"[ERROR] LLM API call failed: {e}")
            raise

class AnthropicClient:
    """Alternative LLM client for Anthropic Claude."""

    def __init__(self, config):
        import anthropic
        self.client = anthropic.Anthropic(api_key=config.API_KEY)
        self.model = config.MODEL

    def ask(self, prompt, system_message=""):
        response = self.client.messages.create(
            model=self.model,
            messages=[{"role": "user", "content": prompt}],
            system=system_message,
            max_tokens=2048
        )
        return response.content[0].text

# ============================================================================
# Pipeline Stages
# ============================================================================

class TestbenchPipeline:
    """Main pipeline orchestrator."""

    def __init__(self,
                 verilog_file: str,
                 specification_file: str,
                 config: Optional[PipelineConfig] = None):
        """
        Initialize the pipeline.

        Args:
            verilog_file: Path to the Verilog design file
            specification_file: Path to the circuit specification file
            config: Optional configuration object
        """
        self.verilog_file = verilog_file
        self.spec_file = specification_file
        self.config = config or PipelineConfig()

        # Create output directory
        self.output_dir = Path(self.config.OUTPUT_DIR)
        self.output_dir.mkdir(exist_ok=True)

        # Initialize LLM client
        if self.config.LLM_PROVIDER == "anthropic":
            self.llm = AnthropicClient(self.config)
        elif self.config.LLM_PROVIDER == "openai":
            self.llm = OpenaiClient(self.config)
        else:
            raise ValueError(f"Unsupported LLM provider: {self.config.LLM_PROVIDER}")

        # Storage for intermediate results
        self.results = {}

    def run(self) -> Dict[str, str]:
        """
        Execute the complete pipeline.

        Returns:
            Dictionary containing all intermediate and final results
        """
        print("=" * 80)
        print("TESTBENCH GENERATION PIPELINE")
        print("=" * 80)
        print(f"Verilog file: {self.verilog_file}")
        print(f"Specification file: {self.spec_file}")
        print(f"Output directory: {self.output_dir}")
        print("=" * 80)
        print()

        try:
            # Stage 1: Analyze RTL and Generate testbench template
            rtl_info = self.step1_analyze_rtl()
            if rtl_info is None:
                print("✗ Pipeline failed at Stage 1.1 (RTL Analysis)")
                raise Exception("RTL analysis failed")

            success = self.step2_generate_testbench_template(rtl_info)
            if not success:
                print("✗ Pipeline failed at Stage 1.2 (Testbench Template)")
                raise Exception("Testbench template generation failed")

            # Stage 3: Generate testcases using LLM
            self.stage3_generate_testcases()

            # Stage 7: Aggregate initial testbench (with testcases from Stage 3)
            success = self.stage7_testbench_aggregation()
            if not success:
                print("✗ Pipeline failed at Stage 7 (Initial Testbench Aggregation)")
                raise Exception("Initial testbench aggregation failed")

            # Stage 8: Coverage gap analysis
            self.stage8_coverage_gap_analysis()

            # Stage 9: Generate testcases from coverage gaps
            self.stage9_generate_testcases_from_gaps()

            # Stage 10: Aggregate all testcases into final testbench
            success = self.stage10_aggregate_all_testcases()
            if not success:
                print("✗ Pipeline failed at Stage 10 (Final Testbench Aggregation)")
                raise Exception("Final testbench aggregation failed")

            # Save final summary
            self.save_summary()

            # Keep intermediate files for debugging
            # (commented out file removal)
            # if os.path.exists(self.output_dir):
            #     import shutil
            #     shutil.rmtree(self.output_dir)


            print("\n" + "=" * 80)
            print("PIPELINE COMPLETED SUCCESSFULLY!")
            print("=" * 80)
            print(f"\nAll outputs saved to: {self.output_dir.absolute()}")
            print(f"\nFinal testbench: testbench_final_complete.sv")

            return self.results

        except Exception as e:
            print(f"\n[ERROR] Pipeline failed: {e}")
            import traceback
            traceback.print_exc()
            raise

    # ========================================================================
    # Stage 1: Analyze RTL and Generate Testbench Template (from baseline)
    # ========================================================================

    def step1_analyze_rtl(self):
        """
        Step 1: Analyze RTL using analyze_rtl.py to extract interface information
        """
        print("\n[Stage 1.1] Analyzing RTL Design...")
        print("-" * 80)

        # Output file for RTL analysis
        rtl_analysis_json = self.output_dir / "step1_rtl_analysis.json"

        # Run analyze_rtl.py and capture output
        result = subprocess.run(
            ["python3", "analyze_rtl.py", self.verilog_file],
            capture_output=True,
            text=True,
            cwd=Path(__file__).parent,
            timeout=120  # 2 minutes for RTL analysis
        )

        if result.returncode != 0:
            print(f"✗ Error running analyze_rtl.py:")
            print(result.stderr)
            return None

        # Print the analysis output
        print(result.stdout)

        # Extract JSON summary from output
        lines = result.stdout.strip().split('\n')
        json_start = -1
        for i, line in enumerate(lines):
            if line.strip() == "SUMMARY (JSON format)":
                json_start = i + 2  # Skip the separator line
                break

        if json_start > 0:
            json_lines = []
            for i in range(json_start, len(lines)):
                if lines[i].startswith('==='):
                    break
                json_lines.append(lines[i])

            json_str = '\n'.join(json_lines)
            try:
                rtl_info = json.loads(json_str)

                # Save to file
                with open(rtl_analysis_json, 'w') as f:
                    json.dump(rtl_info, f, indent=2)

                print(f"\n✓ RTL analysis saved to: {rtl_analysis_json}")
                print()

                return rtl_info

            except json.JSONDecodeError as e:
                print(f"✗ Error parsing JSON output: {e}")
                return None
        else:
            print("✗ Could not find JSON summary in output")
            return None

    def step2_generate_testbench_template(self, rtl_info):
        """
        Step 2: Generate testbench template using the parsed RTL information
        """
        print("\n[Stage 1.2] Generating Testbench Template...")
        print("-" * 80)

        # Parse module information
        print(f"Parsing module details from: {self.verilog_file}")
        parsed_info = tb_gen.parse_verilog_module(self.verilog_file)
        is_seq = tb_gen.is_sequential_circuit(self.verilog_file)

        print(f"Module: {parsed_info['module_name']}")
        print(f"Circuit type: {'sequential' if is_seq else 'combinational'}")
        print(f"Inputs: {len(parsed_info['inputs'])}")
        print(f"Outputs: {len(parsed_info['outputs'])}")

        # IMPORTANT: Reorder outputs to match RTL analysis JSON (step1)
        # This ensures consistent output ordering across all steps
        rtl_output_names = rtl_info['outputs']
        print(f"\nReordering outputs to match RTL analysis: {rtl_output_names}")

        # Create a dict for fast lookup
        parsed_outputs_dict = {out['name']: out for out in parsed_info['outputs']}

        # Reorder outputs according to RTL analysis order
        reordered_outputs = []
        for output_name in rtl_output_names:
            if output_name in parsed_outputs_dict:
                reordered_outputs.append(parsed_outputs_dict[output_name])
            else:
                print(f"Warning: Output '{output_name}' from RTL analysis not found in parsed outputs")

        # Add any outputs that weren't in RTL analysis (shouldn't happen normally)
        for out in parsed_info['outputs']:
            if out['name'] not in rtl_output_names:
                print(f"Warning: Parsed output '{out['name']}' not in RTL analysis")
                reordered_outputs.append(out)

        # Update parsed_info with reordered outputs
        parsed_info['outputs'] = reordered_outputs

        print(f"Final output order: {[out['name'] for out in reordered_outputs]}")
        print()

        # Generate testbench
        testbench_file = self.output_dir / f"{parsed_info['module_name']}_tb.v"
        print(f"Generating testbench template...")
        testbench_content = tb_gen.generate_testbench(
            parsed_info,
            is_seq,
            self.verilog_file,
            str(testbench_file)
        )

        # Store results
        self.results['testbench_template'] = testbench_content
        self.results['testbench_file'] = str(testbench_file)
        self.results['module_info'] = parsed_info
        self.results['is_sequential'] = is_seq

        print(f"✓ Testbench template saved to: {testbench_file}")
        print(f"[Stage 1] Complete. Output: {testbench_file}")
        print()

        return True


    # ========================================================================
    # Stage 3: Generate Testcases with LLM
    # ========================================================================

    def stage3_generate_testcases(self):
        """Use LLM to generate testcases based on specification."""
        print("\n[Stage 3] Generating testcases using LLM...")
        print("-" * 80)

        # Read specification file
        with open(self.spec_file, 'r', encoding='utf-8') as f:
            specification = f.read()

        print(f"Specification loaded ({len(specification)} chars)")

        # Prepare prompt
        prompt = self.config.PROMPT_TESTCASE.format(
            spec=specification,
            template=self.results['testbench_template']
        )

        # Call LLM
        testcases = self.llm.ask(
            prompt,
            system_message="You are an expert in Verilog testbench generation. Generate comprehensive test cases."
        )
        testcases=extract_verilog_code(testcases)

        #remove comments from verilog code
        testcases = remove_verilog_comments(testcases)

        testcases_file =  "./testcases_generated.v"
        with open(testcases_file, 'w', encoding='utf-8') as f:
            f.write(testcases)

        # Store results
        self.results['testcases'] = testcases
        self.results['testcases_file'] = str(testcases_file)

        print(f"[Stage 3] Complete. Output: {testcases_file}")

    # ========================================================================
    # Stage 8: Coverage Gap Analysis
    # ========================================================================

    def stage8_coverage_gap_analysis(self):
        """Generate coverage gap report and use LLM to generate natural language testcases."""
        print("\n[Stage 8] Analyzing coverage gaps and generating natural language testcases...")
        print("-" * 80)

        # Run coverage_gap_report.py to generate coverage report
        print(f"Running coverage_gap_report.py...")

        # Assuming the testbench_final from stage 7 is available
        testbench_file = self.results.get('testbench_final_file')
        coverage_report_file = self.output_dir / "coverage_gap_report.txt"

        try:
            # Run coverage_gap_report.py
            result = subprocess.run(
                ["python3", "coverage_gap_report.py",
                 "--dut", self.verilog_file,
                 "--tb", testbench_file],
                capture_output=True,
                text=True,
                cwd=Path(__file__).parent,
                timeout=300  # 5 minutes for coverage analysis
            )

            if result.returncode != 0:
                print(f"✗ Error running coverage_gap_report.py:")
                print(result.stderr)
                # Save error for debugging
                coverage_report = f"Error: {result.stderr}"
            else:
                full_report = result.stdout
                # Extract only the coverage gaps section
                if "=== Coverage Gaps ===" in full_report:
                    coverage_report = full_report.split("=== Coverage Gaps ===")[1]
                    coverage_report = "=== Coverage Gaps ===" + coverage_report
                    print(f"Coverage gaps extracted ({len(coverage_report)} chars)")
                else:
                    coverage_report = full_report
                    print(f"Coverage report generated ({len(coverage_report)} chars)")

            # Save filtered coverage report
            with open(coverage_report_file, 'w', encoding='utf-8') as f:
                f.write(coverage_report)

            print(f"✓ Coverage report saved to: {coverage_report_file}")

        except Exception as e:
            print(f"✗ Error generating coverage report: {e}")
            coverage_report = f"Error: {str(e)}"
            with open(coverage_report_file, 'w', encoding='utf-8') as f:
                f.write(coverage_report)

        # Read DUT code
        with open(self.verilog_file, 'r', encoding='utf-8') as f:
            dut_code = f.read()

        # Read specification
        with open(self.spec_file, 'r', encoding='utf-8') as f:
            specification = f.read()

        # Prepare prompt for LLM
        prompt = self.config.PROMPT_COVERAGE_GAP.format(
            gap_report=coverage_report,
            dut_code=dut_code,
            spec=specification
        )

        # Call LLM to generate natural language testcases
        print(f"Asking LLM to generate natural language testcases for coverage gaps...")
        nl_testcases = self.llm.ask(
            prompt,
            system_message="You are an expert in hardware verification and coverage analysis. Generate testcases to cover gaps."
        )

        # Save natural language testcases
        nl_testcases_file = self.output_dir / "nl_testcases_from_gaps.txt"
        with open(nl_testcases_file, 'w', encoding='utf-8') as f:
            f.write(nl_testcases)

        # Store results
        self.results['coverage_report'] = coverage_report
        self.results['coverage_report_file'] = str(coverage_report_file)
        self.results['nl_testcases'] = nl_testcases
        self.results['nl_testcases_file'] = str(nl_testcases_file)

        print(f"✓ Natural language testcases saved to: {nl_testcases_file}")
        print(f"[Stage 8] Complete. Output: {nl_testcases_file}")

    # ========================================================================
    # Stage 9: Generate Verilog Testcases from Natural Language
    # ========================================================================

    def stage9_generate_testcases_from_gaps(self):
        """Convert natural language testcases to Verilog testcases using LLM."""
        print("\n[Stage 9] Converting natural language testcases to Verilog...")
        print("-" * 80)

        # Read specification
        with open(self.spec_file, 'r', encoding='utf-8') as f:
            specification = f.read()

        nl_testcases = self.results.get('nl_testcases', '')

        # Count existing testcases to determine starting number
        existing_testcases = self.results.get('testcases', '')
        # Count how many testcase### patterns exist
        import re
        testcase_pattern = r'testcase\d{3}'
        existing_count = len(re.findall(testcase_pattern, existing_testcases))
        start_num = existing_count + 1
        next_num = start_num + 1

        print(f"Existing testcases count: {existing_count}, new testcases will start from: testcase{start_num:03d}")

        # Prepare prompt
        prompt = self.config.PROMPT_TESTCASE_FROM_GAPS.format(
            spec=specification,
            template=self.results['testbench_template'],
            nl_testcases=nl_testcases,
            start_num=start_num,
            next_num=next_num
        )

        # Call LLM
        print(f"Asking LLM to convert natural language testcases to Verilog...")
        testcases_from_gaps = self.llm.ask(
            prompt,
            system_message="You are an expert in Verilog testbench generation. Convert natural language testcases to Verilog."
        )
        testcases_from_gaps = extract_verilog_code(testcases_from_gaps)

        # Remove comments from verilog code
        testcases_from_gaps = remove_verilog_comments(testcases_from_gaps)

        # Save testcases
        testcases_from_gaps_file = self.output_dir / "testcases_from_gaps.v"
        with open(testcases_from_gaps_file, 'w', encoding='utf-8') as f:
            f.write(testcases_from_gaps)

        # Store results
        self.results['testcases_from_gaps'] = testcases_from_gaps
        self.results['testcases_from_gaps_file'] = str(testcases_from_gaps_file)

        print(f"✓ Verilog testcases from gaps saved to: {testcases_from_gaps_file}")
        print(f"[Stage 9] Complete. Output: {testcases_from_gaps_file}")

    def stage7_testbench_aggregation(self):
        """
        Stage 7: Insert testcase file into testbench template to create initial testbench
        """
        print("\n[Stage 7] Generating Initial Testbench (with testcases from Stage 3)...")
        print("-" * 80)

        print(f"Inserting testcases into testbench template...")

        try:
            # Get paths
            testcase_file = self.results.get('testcases_file')
            testbench_template = self.results.get('testbench_file')
            final_testbench_file = "./testbench_final.sv"

            # Modify testcases: add #1; before each check_outputs(
            print(f"Modifying testcases: adding #1; before each check_outputs(...")
            with open(testcase_file, 'r', encoding='utf-8') as f:
                testcases_content = f.read()

            # Add #1; before each check_outputs(
            modified_testcases = re.sub(r'(\s*)check_outputs\(', r'\1#1;\n\1check_outputs(', testcases_content)

            # Save modified testcases back to the file
            with open(testcase_file, 'w', encoding='utf-8') as f:
                f.write(modified_testcases)

            print(f"✓ Testcases modified successfully")

            # Call insert_testcases.py
            result = subprocess.run(
                ["python3",
                 "insert_testcases.py",
                 str(testcase_file),
                 str(testbench_template),
                 str(final_testbench_file)],
                capture_output=True,
                text=True,
                cwd=Path(__file__).parent,
                timeout=30  # 30 seconds for inserting testcases
            )

            if result.returncode == 0:
                # Store results
                self.results['testbench_final_file'] = str(final_testbench_file)

                # Read the final testbench content
                with open(final_testbench_file, 'r', encoding='utf-8') as f:
                    self.results['testbench_final'] = f.read()

                print(f"✓ Initial testbench saved to: {final_testbench_file}")
                print(f"[Stage 7] Complete. Output: {final_testbench_file}")
                return True
            else:
                print(f"✗ Failed to generate initial testbench")
                print(f"  {result.stderr}")
                return False

        except Exception as e:
            print(f"✗ Error generating initial testbench: {e}")
            import traceback
            traceback.print_exc()
            return False

    # ========================================================================
    # Stage 10: Aggregate All Testcases
    # ========================================================================

    def stage10_aggregate_all_testcases(self):
        """
        Stage 10: Aggregate all testcases (from Stage 3 and Stage 9) into final testbench
        """
        print("\n[Stage 10] Aggregating All Testcases into Final Testbench...")
        print("-" * 80)

        try:
            # Get paths
            testcase_file1 = self.results.get('testcases_file')  # From Stage 3
            testcase_file2 = self.results.get('testcases_from_gaps_file')  # From Stage 9
            testbench_template = self.results.get('testbench_file')
            final_testbench_file = "./testbench_final_complete.sv"

            # Combine both testcase files
            combined_testcases_file = self.output_dir / "testcases_combined.v"

            print(f"Combining testcases from Stage 3 and Stage 9...")
            with open(testcase_file1, 'r', encoding='utf-8') as f:
                testcases1 = f.read()

            with open(testcase_file2, 'r', encoding='utf-8') as f:
                testcases2 = f.read()

            # Combine testcases
            combined_testcases = testcases1 + "\n\n" + testcases2

            # Modify combined testcases: add #1; before each check_outputs(
            print(f"Modifying combined testcases: adding #1; before each check_outputs(...")
            modified_testcases = re.sub(r'(\s*)check_outputs\(', r'\1#1;\n\1check_outputs(', combined_testcases)

            # Save combined testcases
            with open(combined_testcases_file, 'w', encoding='utf-8') as f:
                f.write(modified_testcases)

            print(f"✓ Combined testcases saved to: {combined_testcases_file}")

            # Call insert_testcases.py with combined testcases
            result = subprocess.run(
                ["python3",
                 "insert_testcases.py",
                 str(combined_testcases_file),
                 str(testbench_template),
                 str(final_testbench_file)],
                capture_output=True,
                text=True,
                cwd=Path(__file__).parent,
                timeout=30  # 30 seconds for inserting testcases
            )

            if result.returncode == 0:
                # Store results
                self.results['testbench_final_complete_file'] = str(final_testbench_file)
                self.results['combined_testcases_file'] = str(combined_testcases_file)

                # Read the final testbench content
                with open(final_testbench_file, 'r', encoding='utf-8') as f:
                    self.results['testbench_final_complete'] = f.read()

                print(f"✓ Final complete testbench saved to: {final_testbench_file}")
                print(f"[Stage 10] Complete. Output: {final_testbench_file}")
                return True
            else:
                print(f"✗ Failed to generate final complete testbench")
                print(f"  {result.stderr}")
                return False

        except Exception as e:
            print(f"✗ Error generating final complete testbench: {e}")
            import traceback
            traceback.print_exc()
            return False




    # ========================================================================
    # Summary
    # ========================================================================

    def save_summary(self):
        """Save a summary of all pipeline outputs."""
        summary_file = self.output_dir / "pipeline_summary.json"

        summary = {
            "input_files": {
                "verilog_design": self.verilog_file,
                "specification": self.spec_file
            },
            "output_files": {
                "stage1_rtl_analysis": str(self.output_dir / "step1_rtl_analysis.json"),
                "stage1_testbench_template": self.results.get('testbench_file'),
                "stage3_testcases_generated": self.results.get('testcases_file'),
                "stage7_testbench_initial": self.results.get('testbench_final_file'),
                "stage8_coverage_report": self.results.get('coverage_report_file'),
                "stage8_nl_testcases": self.results.get('nl_testcases_file'),
                "stage9_testcases_from_gaps": self.results.get('testcases_from_gaps_file'),
                "stage10_combined_testcases": self.results.get('combined_testcases_file'),
                "stage10_testbench_final_complete": self.results.get('testbench_final_complete_file')
            },
            "module_info": {
                "name": self.results['module_info']['module_name'],
                "inputs": [inp['name'] for inp in self.results['module_info']['inputs']],
                "outputs": [out['name'] for out in self.results['module_info']['outputs']],
                "circuit_type": "sequential" if self.results['is_sequential'] else "combinational"
            }
        }

        with open(summary_file, 'w', encoding='utf-8') as f:
            json.dump(summary, f, indent=2)

        print(f"\n[Summary] Pipeline summary saved to: {summary_file}")


# ============================================================================
# Command-Line Interface
# ============================================================================

def main():
    """Main entry point for command-line usage."""
    if len(sys.argv) < 3:
        print(__doc__)
        print("\nUsage:")
        print("  python tb_pipeline.py <verilog_file> <specification_file>")
        print("\nExample:")
        print("  python tb_pipeline.py design.sv spec.txt")
        sys.exit(1)

    verilog_file = sys.argv[1]
    spec_file = sys.argv[2]

    # Validate input files
    if not os.path.exists(verilog_file):
        print(f"Error: Verilog file not found: {verilog_file}")
        sys.exit(1)

    if not os.path.exists(spec_file):
        print(f"Error: Specification file not found: {spec_file}")
        sys.exit(1)

    # Create and run pipeline
    pipeline = TestbenchPipeline(verilog_file, spec_file)
    results = pipeline.run()


if __name__ == "__main__":
    main()
