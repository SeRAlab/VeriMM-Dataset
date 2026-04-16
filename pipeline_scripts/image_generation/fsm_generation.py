#!/usr/bin/env python3
"""
Standalone FSM Figure Generator from Verilog Code

This script generates FSM figures from Verilog code using Verdi to extract FSM information
and Graphviz to generate the visualization.

Usage:
    python fsm_generation.py <verilog_file> [options]

Options:
    -o, --output <name>    Output file name (without extension, default: based on input file)
    -f, --format <fmt>     Output format: svg, png, pdf (default: svg)
    --fsm-name <name>      Specific FSM instance name (if known, skips auto-detection)
    --keep-temp           Keep temporary files after generation
    -v, --verbose         Verbose output

Example:
    python fsm_generation.py design.v -o fsm_output -f svg
"""

import os
import re
import sys
import argparse
import tempfile
import shutil
from datetime import datetime
from typing import List, Dict, Tuple, Optional
from pathlib import Path

try:
    from graphviz import Source
    GRAPHVIZ_AVAILABLE = True
except ImportError:
    GRAPHVIZ_AVAILABLE = False
    print("Error: graphviz module not available. Install with: pip install graphviz")
    sys.exit(1)


# Color codes for terminal output
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
RESET = "\033[0m"


class FSMToGraphvizConverter:
    """Converts Verdi FSM format to Graphviz DOT format."""

    def __init__(self):
        self.states = {}
        self.transitions = []

    def parse_fsm_file(self, file_path: str) -> str:
        """
        Parse FSM file and convert to Graphviz format.

        Args:
            file_path: Path to the FSM file

        Returns:
            Graphviz DOT format string
        """
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        return self.convert_fsm_to_graphviz(content)

    def parse_fsm_content(self, content: str) -> str:
        """
        Parse FSM content string and convert to Graphviz format.

        Args:
            content: FSM content as string

        Returns:
            Graphviz DOT format string
        """
        return self.convert_fsm_to_graphviz(content)

    def convert_fsm_to_graphviz(self, content: str) -> str:
        """
        Convert FSM content to Graphviz DOT format.

        Args:
            content: FSM file content

        Returns:
            Graphviz DOT format string
        """
        self.states = {}
        self.transitions = []

        lines = content.split('\n')
        i = 0

        while i < len(lines):
            line = lines[i].strip()

            # Skip empty lines and headers
            if not line or line.startswith('=') or line.startswith('-') or \
               line.startswith('Finite State Machine') or \
               line.startswith('Input Signals') or line.startswith('Output Signals') or \
               line.startswith('Clock') or line.startswith('Reset') or \
               line.startswith('State Signal') or line.startswith('Initial State') or \
               line.startswith('State Table') or line.startswith('Detail State Report'):
                i += 1
                continue

            # Parse state definitions from State Table section
            if '=' in line and ("'b" in line or line.endswith('=Others') or line.endswith('=4\'bXXXX')):
                state_name, state_value = line.split('=', 1)
                self.states[state_name.strip()] = state_value.strip()
                i += 1
                continue

            # Parse detailed state information - look for lines with StateType
            if 'StateType' in line:
                # Extract state name from line like "XXXX    StateType: Looped"
                parts = line.split('StateType')
                if len(parts) >= 2:
                    state_name = parts[0].strip()

                    # Look for Transitions: line
                    j = i + 1
                    while j < len(lines) and j < i + 10:
                        if lines[j].strip() == 'Transitions:':
                            # Found transitions, now parse them
                            k = j + 1
                            while k < len(lines):
                                line_content = lines[k].strip()
                                if line_content.startswith('->'):
                                    self._parse_transition(state_name, line_content)
                                elif line_content == '' or line_content.startswith('#'):
                                    # Empty line or output assignment, continue
                                    pass
                                elif line_content.startswith('State Outputs:') or line_content.startswith('-'):
                                    # End of transitions section
                                    break
                                else:
                                    # Some other content, might be end of state section
                                    break
                                k += 1
                            break
                        j += 1

            i += 1

        return self._generate_graphviz()

    def _parse_transition(self, from_state: str, transition_line: str):
        """Parse a single transition line."""
        # Remove '->' prefix and leading/trailing spaces
        transition_line = transition_line[2:].strip()

        # Find the first space to separate state name from condition
        space_index = transition_line.find(' ')

        if space_index == -1:
            # No condition, just state name
            to_state = transition_line
            condition = ""
        else:
            # Split at first space
            to_state = transition_line[:space_index]
            condition = transition_line[space_index + 1:].strip()

        self.transitions.append((from_state, to_state, condition))

    def _generate_graphviz(self) -> str:
        """Generate Graphviz DOT format from parsed data."""
        result = ["digraph FSM {"]

        # Add transitions
        for from_state, to_state, condition in self.transitions:
            if condition:
                result.append(f"    {from_state} -> {to_state} [label=\"{condition}\"];")
            else:
                result.append(f"    {from_state} -> {to_state};")

        result.append("}")
        return '\n'.join(result)


def convert_fsm_file(input_file: str, output_file: Optional[str] = None) -> str:
    """
    Convert FSM file to Graphviz format.

    Args:
        input_file: Path to input FSM file
        output_file: Optional path to output file. If None, returns string only.

    Returns:
        Graphviz DOT format string
    """
    converter = FSMToGraphvizConverter()
    graphviz_content = converter.parse_fsm_file(input_file)

    if output_file:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(graphviz_content)

    return graphviz_content


class FSMGenerator:
    """Main FSM generator class that orchestrates the entire process."""

    def __init__(self, verilog_file: str, output_name: str = None,
                 output_format: str = 'svg', fsm_name: str = None,
                 keep_temp: bool = False, verbose: bool = False):
        self.verilog_file = os.path.abspath(verilog_file)
        self.output_name = output_name or self._get_default_output_name()
        self.output_format = output_format
        self.specified_fsm_name = fsm_name
        self.keep_temp = keep_temp
        self.verbose = verbose
        self.temp_dir = None
        self.log_file = "fsm_generation.log"

    def _get_default_output_name(self) -> str:
        """Generate default output name from input file."""
        base_name = os.path.basename(self.verilog_file)
        name_without_ext = os.path.splitext(base_name)[0]
        return f"{name_without_ext}_fsm"

    def _extract_module_name(self) -> Optional[str]:
        """Extract the module name from the Verilog file."""
        try:
            with open(self.verilog_file, 'r', encoding='utf-8') as f:
                content = f.read()

            # Pattern to match module declaration
            # Handles: module name (...) or module name;
            pattern = r'^\s*module\s+(\w+)\s*[;(]'

            for line in content.split('\n'):
                match = re.match(pattern, line)
                if match:
                    module_name = match.group(1)
                    self.log(f"Extracted module name: {module_name}")
                    return module_name

            self.log("No module declaration found in Verilog file", "WARNING")
            return None

        except Exception as e:
            self.log(f"Error reading Verilog file: {e}", "ERROR")
            return None

    def log(self, message: str, level: str = "INFO"):
        """Write message to log file and optionally print."""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_message = f"[{timestamp}] [{level}] {message}"

        # with open(self.log_file, "a") as f:
        #     f.write(log_message + "\n")

        if self.verbose or level == "ERROR":
            color = GREEN if level == "INFO" else (YELLOW if level == "WARNING" else RED)
            print(f"{color}{log_message}{RESET}")

    def _create_makefile(self, temp_dir: str):
        """Create Makefile for Verdi commands."""
        makefile_content = """find:
\tfind -name "*.v" -o -name "*.sv" > file.list
get_fsm_name:
\tverdi -play fsm_name.cmd -nologo -batch
get_fsm_code:
\tverdi -play fsm_code.cmd -nologo -batch
clean:
\trm -rf *.vpd csrc *.key *.vpd simv* DVE* *.fsdb *.bak *.conf *.list *.rc *.cmd *.txt *.dot
"""
        makefile_path = os.path.join(temp_dir, "Makefile")
        with open(makefile_path, "w") as f:
            f.write(makefile_content)

    def _create_fsm_name_cmd(self, temp_dir: str, module_name: str):
        """Create Verdi command file to get FSM name."""
        fsm_name_file = os.path.join(temp_dir, "fsm_name.txt")
        cmd_content = f"""debImport "-sv" "-f" "file.list"
schCreateWindow -delim "." -win $_nSchema1 -scope "{module_name}"
schSaveCurrentScope -win $_nSchema2 -filter "*FSM*" -inst -file "{fsm_name_file}"
debExit
"""
        cmd_path = os.path.join(temp_dir, "fsm_name.cmd")
        with open(cmd_path, "w") as f:
            f.write(cmd_content)

    def _create_fsm_code_cmd(self, temp_dir: str, fsm_name: str, module_name: str):
        """Create Verdi command file to extract FSM code."""
        cmd_content = f"""debImport "-sv" "-f" "file.list"
schCreateWindow -delim "." -win $_nSchema1 -scope "{module_name}"
schSelect -win $_nSchema2 -inst "{fsm_name}"
schPushViewIn -win $_nSchema2
fsmSetCurrentWindow -win $_nState3
fsmResizeWindow 0 27 710 255 -win $_nState3
fsmResizeWindow 0 27 710 255 -win $_nState3
fsmResizeWindow 0 27 710 255 -win $_nState3
fsmResizeWindow 0 27 710 255 -win $_nState3
fsmResizeWindow 0 27 710 255 -win $_nState3
fsmSetOptions -transCondition 1 -win $_nState3
fsmPrint \\
         -orient portrait -paper A4 -marginLeft 684 -marginRight 684 -marginTop 684 -marginBottom 684 -header "%h @ %t" -footer "%w" -type PS1 -printer "lp" -rows 1 -cols 1 -printReport \\
         -win $_nState3
srcPrint -win $_nTrace4 -column 2 -fontSize 7 -lineNum off -indicator off -annot \\
         off -orient portrait -paper A4 -marginLeft 684 -marginRight 684 \\
         -marginTop 684 -marginBottom 684 -header "%h @ %t" -type PS1 -printer \\
         "lp"
srcSaveAs -win $_nTrace4 -file fsm_code.txt
srcCloseWindow -win $_nTrace4
debExit
"""
        cmd_path = os.path.join(temp_dir, "fsm_code.cmd")
        with open(cmd_path, "w") as f:
            f.write(cmd_content)

    def get_fsm_name(self, temp_dir: str, module_name: str) -> Optional[str]:
        """Get FSM name from the design using Verdi."""
        if self.specified_fsm_name:
            self.log(f"Using specified FSM name: {self.specified_fsm_name}")
            return self.specified_fsm_name

        self.log("Detecting FSM name using Verdi...")
        self._create_fsm_name_cmd(temp_dir, module_name)

        result = os.system(f"cd {temp_dir} && make get_fsm_name > /dev/null 2>&1")

        fsm_name_file = os.path.join(temp_dir, "fsm_name.txt")
        if os.path.exists(fsm_name_file):
            with open(fsm_name_file, "r") as f:
                fsm_name = f.read().strip()

            # Filter out non-FSM instances
            if fsm_name == "None" or not fsm_name:
                self.log("No FSM found in the design", "WARNING")
                return None

            if fsm_name.endswith("Counter"):
                self.log(f"Skipping counter instance: {fsm_name}", "WARNING")
                return None

            self.log(f"Found FSM: {fsm_name}")
            return fsm_name

        self.log("Failed to detect FSM name", "ERROR")
        return None

    def get_fsm_code(self, temp_dir: str, fsm_name: str, module_name: str) -> bool:
        """Extract FSM code using Verdi."""
        self.log(f"Extracting FSM code for: {fsm_name}")
        self._create_fsm_code_cmd(temp_dir, fsm_name, module_name)

        result = os.system(f"cd {temp_dir} && make get_fsm_code > /dev/null 2>&1")

        if result == 512:
            self.log("FSM code extraction failed", "ERROR")
            return False

        fsm_code_file = os.path.join(temp_dir, "fsm_code.txt")
        if os.path.exists(fsm_code_file):
            self.log("FSM code extracted successfully")
            return True

        self.log("FSM code file not generated", "ERROR")
        return False

    def generate_diagram(self, temp_dir: str) -> bool:
        """Generate FSM diagram from extracted code."""
        self.log("Converting FSM code to Graphviz format...")

        fsm_code_file = os.path.join(temp_dir, "fsm_code.txt")
        dot_file = os.path.join(temp_dir, "output.dot")

        try:
            dot_content = convert_fsm_file(fsm_code_file, dot_file)
            self.log("Graphviz DOT file generated")
        except Exception as e:
            self.log(f"Failed to convert FSM to Graphviz: {e}", "ERROR")
            return False

        # Generate the final diagram
        self.log(f"Generating {self.output_format.upper()} diagram...")

        try:
            with open(dot_file, "r") as f:
                dot_code = f.read()

            s = Source(dot_code)
            s.render(filename=self.output_name, format=self.output_format,
                    cleanup=True, directory=".")

            output_file = f"{self.output_name}.{self.output_format}"
            self.log(f"FSM diagram generated: {output_file}")
            print(f"{GREEN}Success! FSM diagram saved to: {output_file}{RESET}")
            return True

        except Exception as e:
            self.log(f"Failed to generate diagram: {e}", "ERROR")
            print(f"{RED}Error: {e}{RESET}")
            return False

    def generate(self) -> bool:
        """Main method to generate FSM diagram."""
        # Check if Verdi is available
        verdi_check = os.system("which verdi > /dev/null 2>&1")
        if verdi_check != 0:
            print(f"{RED}Error: Verdi is not available. Please ensure Verdi is installed and in PATH.{RESET}")
            return False

        # Create temporary directory
        self.temp_dir = tempfile.mkdtemp(prefix="fsm_gen_")
        self.log(f"Working in temporary directory: {self.temp_dir}")

        try:
            # Copy verilog file to temp directory
            verilog_basename = os.path.basename(self.verilog_file)
            temp_verilog = os.path.join(self.temp_dir, verilog_basename)
            shutil.copy(self.verilog_file, temp_verilog)

            # Create Makefile
            self._create_makefile(self.temp_dir)

            # Create file list
            os.system(f"cd {self.temp_dir} && make find > /dev/null 2>&1")

            # Extract module name from Verilog file
            module_name = self._extract_module_name()
            if not module_name:
                print(f"{RED}Error: Could not extract module name from Verilog file{RESET}")
                return False

            # Get FSM name
            fsm_name = self.get_fsm_name(self.temp_dir, module_name)
            if not fsm_name:
                print(f"{YELLOW}No FSM found in the design{RESET}")
                return False

            # Extract FSM code
            if not self.get_fsm_code(self.temp_dir, fsm_name, module_name):
                print(f"{RED}Failed to extract FSM code{RESET}")
                return False

            # Generate diagram
            if not self.generate_diagram(self.temp_dir):
                return False

            # Delete log file on successful generation
            if os.path.exists(self.log_file):
                try:
                    os.remove(self.log_file)
                    if self.verbose:
                        print(f"{GREEN}Log file deleted after successful generation{RESET}")
                except Exception as e:
                    if self.verbose:
                        print(f"{YELLOW}Warning: Could not delete log file: {e}{RESET}")

            return True

        finally:
            # Clean up temporary directory
            if not self.keep_temp and self.temp_dir:
                self.log(f"Cleaning up temporary directory: {self.temp_dir}")
                shutil.rmtree(self.temp_dir, ignore_errors=True)
            elif self.keep_temp:
                print(f"{YELLOW}Temporary files kept in: {self.temp_dir}{RESET}")


def main():
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description='Generate FSM diagrams from Verilog code using Verdi and Graphviz',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
Examples:
  %(prog)s design.v
  %(prog)s design.sv -o my_fsm -f png
  %(prog)s design.v --fsm-name "my_fsm_inst" --verbose
        '''
    )

    parser.add_argument('verilog_file', help='Input Verilog/SystemVerilog file')
    parser.add_argument('-o', '--output', help='Output file name (without extension)')
    parser.add_argument('-f', '--format', default='svg',
                       choices=['svg', 'png', 'pdf'],
                       help='Output format (default: svg)')
    parser.add_argument('--fsm-name', help='Specific FSM instance name (skips auto-detection)')
    parser.add_argument('--keep-temp', action='store_true',
                       help='Keep temporary files after generation')
    parser.add_argument('-v', '--verbose', action='store_true',
                       help='Verbose output')

    args = parser.parse_args()
    # Check if input file exists
    if not os.path.exists(args.verilog_file):
        print(f"{RED}Error: File '{args.verilog_file}' not found{RESET}")
        sys.exit(1)

    # Create generator and run
    generator = FSMGenerator(
        verilog_file=args.verilog_file,
        output_name=args.output,
        output_format=args.format,
        fsm_name=args.fsm_name,
        keep_temp=args.keep_temp,
        verbose=args.verbose
    )

    success = generator.generate()
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
