#!/usr/bin/env python
"""
Generate timing diagram SVGs from Verilog testbenches
Usage: python timing_diagram_generation.py <dut_file> <testbench_file> [options]
Example: python timing_diagram_generation.py design.v testbench.sv --sim-timeout 120
"""

import os
import sys
import subprocess
import json
import argparse
import re
import tempfile
from wavedrom import render
from vcd2wavedrom import VCD2Wavedrom


def sequential_circuit(file_name):
    """Check if a Verilog file contains sequential circuit elements"""
    with open(file_name, 'r') as f:
        content = f.read()
        if 'always_ff' in content or 'posedge' in content or 'negedge' in content:
            return True
    return False


def parse_simulation_statistics(log: str) -> str:
    """Parse simulation log to extract only test pass/fail statistics."""
    if not log:
        return "No simulation performed"

    # Look for common patterns in simulation logs
    lines = log.split('\n')
    stats = []

    for line in lines:
        # Look for patterns like "X tests passed", "X/Y passed", etc.
        if 'test' in line.lower() and ('pass' in line.lower() or 'fail' in line.lower()):
            stats.append(line.strip())
        elif 'testcase' in line.lower() and ('pass' in line.lower() or 'fail' in line.lower()):
            stats.append(line.strip())
        # Look for summary patterns
        elif any(keyword in line.lower() for keyword in ['total:', 'summary:', 'result:']):
            if 'pass' in line.lower() or 'fail' in line.lower():
                stats.append(line.strip())

    if stats:
        return '\n'.join(stats)
    else:
        return log.strip()


def run_simulation_for_test(dut_path, tb_path, compile_timeout=30, sim_timeout=60):
    """Run iverilog simulation and return the log output."""
    vvp_file = "test_sim.vvp"

    # Compile with iverilog
    compile_cmd = ['iverilog', '-o', vvp_file, tb_path, dut_path, '-g2012']
    compile_result = subprocess.run(compile_cmd, capture_output=True, text=True, timeout=compile_timeout)

    if compile_result.returncode != 0:
        return None, None

    # Run simulation with vvp
    sim_cmd = ['vvp', '-n', vvp_file]
    sim_result = subprocess.run(sim_cmd, capture_output=True, text=True, timeout=sim_timeout)

    # Clean up
    if os.path.exists(vvp_file):
        os.remove(vvp_file)
    if os.path.exists('wave.vcd'):
        os.remove('wave.vcd')

    full_log = sim_result.stdout + sim_result.stderr
    parsed_log = parse_simulation_statistics(full_log)

    return full_log, parsed_log


def parse_test_results(log):
    """Parse log to determine number of passed and failed tests."""
    passed = 0
    failed = 0

    # Look for "Tests Passed: X" and "Tests Failed: Y"
    pass_match = re.search(r'Tests Passed:\s*(\d+)', log)
    fail_match = re.search(r'Tests Failed:\s*(\d+)', log)

    if pass_match:
        passed = int(pass_match.group(1))
    if fail_match:
        failed = int(fail_match.group(1))

    return passed, failed


def count_testcases(testbench_file):
    """Count the number of testcase calls in the testbench."""
    testcase_pattern = re.compile(r'^\s*testcase\d+\(\);')
    count = 0

    with open(testbench_file, 'r') as f:
        for line in f:
            if testcase_pattern.match(line):
                count += 1

    return count


def comment_testcases_except(testbench_file, keep_testcase_index):
    """
    Comment out all testcase calls except the specified one.
    Returns the modified content as a string.
    """
    with open(testbench_file, 'r') as f:
        lines = f.readlines()

    testcase_pattern = re.compile(r'^(\s*)(testcase\d+\(\);.*)$')
    testcase_count = 0

    for i, line in enumerate(lines):
        match = testcase_pattern.match(line)
        if match:
            testcase_count += 1
            indent = match.group(1)
            testcase_call = match.group(2)

            if testcase_count != keep_testcase_index:
                lines[i] = f"{indent}//{testcase_call}\n"

    return ''.join(lines), testcase_count


def comment_all_testcases(testbench_file):
    """Comment out all testcase calls. Returns the modified content as a string."""
    with open(testbench_file, 'r') as f:
        lines = f.readlines()

    testcase_pattern = re.compile(r'^(\s*)(testcase\d+\(\);.*)$')

    for i, line in enumerate(lines):
        match = testcase_pattern.match(line)
        if match:
            indent = match.group(1)
            testcase_call = match.group(2)
            lines[i] = f"{indent}//{testcase_call}\n"

    return ''.join(lines)


def find_passing_testcase(dut_path, tb_path, total_testcases, compile_timeout, sim_timeout):
    """
    Test each testcase individually in order: 2nd, 3rd, 4th, ..., 1st
    Return the index of the first passing testcase found, or None.
    """
    # Test order: 2, 3, 4, ..., total_testcases, 1
    test_order = list(range(2, total_testcases + 1)) + [1]

    for testcase_idx in test_order:
        print(f"    → Testing testcase #{testcase_idx}...", end=' ')

        # Create temporary testbench with only this testcase
        temp_tb = f"temp_tb_{testcase_idx}.v"

        modified_content, _ = comment_testcases_except(tb_path, testcase_idx)

        with open(temp_tb, 'w') as f:
            f.write(modified_content)

        try:
            # Run simulation
            full_log, parsed_log = run_simulation_for_test(dut_path, temp_tb, compile_timeout, sim_timeout)

            if full_log is None:
                print(f"✗ Failed")
                continue

            # Check if this testcase passed
            passed, failed = parse_test_results(full_log)

            if passed > 0 and failed == 0:
                print(f"✓ PASSED")
                return testcase_idx
            else:
                print(f"✗ Failed (passed={passed}, failed={failed})")

        except Exception as e:
            print(f"✗ Error: {str(e)}")
            continue
        finally:
            # Clean up temp file
            if os.path.exists(temp_tb):
                os.remove(temp_tb)

    return None


def optimize_testbench(dut_path, tb_path, compile_timeout=30, sim_timeout=60):
    """
    Optimize testbench by finding a passing testcase.
    Returns the path to the optimized testbench (or original if no optimization needed).
    """
    print(f"\n{'='*60}")
    print(f"OPTIMIZING TESTBENCH")
    print(f"{'='*60}")

    # Step 1: Run full simulation
    print(f"  [1/3] Running full simulation to check testcases...")
    try:
        full_log, parsed_log = run_simulation_for_test(dut_path, tb_path, compile_timeout, sim_timeout)

        if full_log is None:
            print(f"  ✗ Initial simulation failed, using original testbench")
            return tb_path

        print(f"\n  Initial Simulation Results:")
        for line in parsed_log.split('\n')[:5]:  # Show first 5 lines
            print(f"    {line}")

    except Exception as e:
        print(f"  ✗ Simulation error: {str(e)}, using original testbench")
        return tb_path

    # Step 2: Analyze results
    print(f"\n  [2/3] Analyzing test results...")
    passed, failed = parse_test_results(full_log)
    total = passed + failed

    if total == 0:
        print(f"    No testcases detected, using original testbench")
        return tb_path

    print(f"    Tests Passed: {passed}/{total}")
    print(f"    Tests Failed: {failed}/{total}")

    # Step 3: Optimize testbench
    print(f"\n  [3/3] Optimizing testbench...")

    if passed == 0 and failed > 0:
        # All tests failed - comment out all testcases
        print(f"    All testcases failed - commenting out all testcases")

        optimized_tb = tb_path.replace('.v', '_optimized.v').replace('.sv', '_optimized.sv')
        modified_content = comment_all_testcases(tb_path)

        with open(optimized_tb, 'w') as f:
            f.write(modified_content)

        print(f"    ✓ Optimized testbench: {optimized_tb}")
        return optimized_tb

    elif passed > 0:
        # At least one test passed - find which one
        print(f"    At least one testcase passed - finding best testcase...")

        total_testcases = count_testcases(tb_path)
        print(f"    Total testcases: {total_testcases}")

        if total_testcases == 0:
            print(f"    No testcase calls found, using original testbench")
            return tb_path

        passing_testcase_idx = find_passing_testcase(dut_path, tb_path, total_testcases, compile_timeout, sim_timeout)

        if passing_testcase_idx:
            # Create optimized testbench with only the passing testcase
            optimized_tb = tb_path.replace('.v', '_optimized.v').replace('.sv', '_optimized.sv')
            modified_content, _ = comment_testcases_except(tb_path, passing_testcase_idx)

            with open(optimized_tb, 'w') as f:
                f.write(modified_content)

            print(f"    ✓ Optimized testbench with testcase #{passing_testcase_idx}: {optimized_tb}")
            return optimized_tb
        else:
            print(f"    ✗ No single passing testcase found, using original testbench")
            return tb_path
    else:
        print(f"    No tests were run or detected, using original testbench")
        return tb_path


def gen_wavedrom():
    with open("wave.vcd", 'r') as f:
        input_text = f.read()
    config = {
        'input': "wave.vcd",
        'input_text': input_text,
        'output': None,  # None means output to stdout
    }

    try:
        # Create VCD2Wavedrom instance and execute
        vcd = VCD2Wavedrom(config)
        drom = vcd.execute(True)  # True for auto-config mode

        # Convert to JSON string
        result = json.dumps(drom, indent=4)
        return result

    except Exception as e:
        print(f"Error occurred while converting VCD to Wavedrom:")
        print(str(e))
        return ""


def gen_vcd(dut_path, tb_path, compile_timeout=30, sim_timeout=60):
    """Generate VCD file from Verilog simulation

    Args:
        dut_path: Path to DUT file
        tb_path: Path to testbench file
        compile_timeout: Timeout in seconds for compilation (default: 30)
        sim_timeout: Timeout in seconds for simulation (default: 60)
    """
    print(f"  → Compiling Verilog files...")
    compile_cmd = ["iverilog", "-o", "sim.vvp", tb_path, dut_path, "-g2012"]

    try:
        result1 = subprocess.run(
            compile_cmd,
            timeout=compile_timeout,
            text=True
        )

        if result1.returncode != 0:
            print(f"  ✗ Compilation failed")
            return False

    except subprocess.TimeoutExpired:
        print(f"  ✗ Compilation timeout after {compile_timeout}s")
        return False
    except Exception as e:
        print(f"  ✗ Compilation error: {str(e)}")
        return False

    print(f"  → Running simulation (timeout: {sim_timeout}s)...")
    sim_cmd = ["vvp", "-n", "sim.vvp"]

    try:
        result2 = subprocess.run(
            sim_cmd,
            timeout=sim_timeout,
            text=True
        )

        if result2.returncode != 0:
            print(f"  ✗ Simulation failed")
            return False

    except subprocess.TimeoutExpired:
        print(f"  ✗ Simulation timeout after {sim_timeout}s")
        print(f"     The simulation may contain an infinite loop or took too long")
        return False
    except Exception as e:
        print(f"  ✗ Simulation error: {str(e)}")
        return False

    return True


def remove_signal_prefix(wave_data):
    """Remove DUT/module name prefix from signal names"""
    if 'signal' in wave_data:
        for signal in wave_data['signal']:
            if 'name' in signal and '.' in signal['name']:
                # Remove everything before and including the last dot
                signal['name'] = signal['name'].split('.')[-1]
    return wave_data


def generate_svg(wave_data, output_path):
    """Generate SVG from wavedrom JSON data"""
    try:
        # Remove signal prefixes
        wave_data = remove_signal_prefix(wave_data)

        wave_json = json.dumps(wave_data)
        svg = render(wave_json)
        svg.saveas(output_path)
        print(f"  ✓ SVG saved: {output_path}")
        return True
    except Exception as e:
        print(f"  ✗ Failed to generate SVG: {str(e)}")
        return False


def get_base_name(file_path):
    """Get base name from file path (without extension)"""
    base = os.path.basename(file_path)
    # Remove common suffixes
    for suffix in ['_ref.sv', '_ref.v', '.sv', '.v']:
        if base.endswith(suffix):
            base = base[:-len(suffix)]
            break
    return base


def process_files(dut_path, tb_path, compile_timeout=30, sim_timeout=60):
    """Process DUT and testbench files to generate timing diagram

    Args:
        dut_path: Path to DUT file
        tb_path: Path to testbench file
        compile_timeout: Timeout in seconds for compilation (default: 30)
        sim_timeout: Timeout in seconds for simulation (default: 60)
    """
    print(f"\n{'='*60}")
    print(f"GENERATING TIMING DIAGRAM")
    print(f"{'='*60}")
    print(f"DUT:        {dut_path}")
    print(f"Testbench:  {tb_path}")
    print('='*60)

    # Check if files exist
    if not os.path.exists(dut_path):
        print(f"  ✗ DUT file not found: {dut_path}")
        return False

    if not os.path.exists(tb_path):
        print(f"  ✗ Testbench file not found: {tb_path}")
        return False

    # Generate VCD file
    if not gen_vcd(dut_path, tb_path, compile_timeout, sim_timeout):
        return False

    # Check if it's a sequential circuit
    if not sequential_circuit(dut_path):
        print(f"  → Skipping (combinational circuit)")
        return False


    if not os.path.exists('wave.vcd'):
        print(f"  ✗ VCD file not generated")
        return False

    # Convert VCD to Wavedrom JSON
    print(f"  → Converting to Wavedrom JSON...")
    wave = gen_wavedrom()

    if not wave:
        print(f"  ✗ Wavedrom generation failed")
        cleanup()
        return False

    # Get base name for output files
    base_name = get_base_name(dut_path)

    # Generate SVG
    print(f"  → Generating SVG...")
    wave_data = json.loads(wave)
    svg_file_name = f"{base_name}_wavedrom.svg"
    generate_svg(wave_data, svg_file_name)

    # Cleanup temporary files
    cleanup()

    return True


def cleanup():
    """Remove temporary files"""
    if os.path.exists('wave.vcd'):
        os.remove('wave.vcd')
    if os.path.exists('sim.vvp'):
        os.remove('sim.vvp')


def print_usage():
    """Print usage information"""
    print("Usage: python timing_diagram_generation.py <dut_file> <testbench_file> [options]")
    print("\nPositional Arguments:")
    print("  dut_file        Path to DUT (Design Under Test) Verilog file")
    print("  testbench_file  Path to testbench Verilog file")
    print("\nOptional Arguments:")
    print("  --compile-timeout SECONDS  Timeout for compilation (default: 30)")
    print("  --sim-timeout SECONDS      Timeout for simulation (default: 60)")
    print("\nExamples:")
    print("  python timing_diagram_generation.py design.v testbench.sv")
    print("  python timing_diagram_generation.py design.v testbench.sv --sim-timeout 120")
    print("  python timing_diagram_generation.py Prob155_lemmings4_ref.sv Prob155_lemmings4_test.sv")
    print("\nOutput:")
    print("  <basename>_wavedrom.svg  - Timing diagram SVG")
    print("\nEnvironment Variables:")
    print("  VERILOG_COMPILE_TIMEOUT  - Default compilation timeout (seconds)")
    print("  VERILOG_SIM_TIMEOUT      - Default simulation timeout (seconds)")


def parse_arguments():
    """Parse command-line arguments"""
    parser = argparse.ArgumentParser(
        description='Generate timing diagram SVGs from Verilog testbenches',
        add_help=False  # Custom help message
    )

    parser.add_argument('dut_file', nargs='?', help='Path to DUT Verilog file')
    parser.add_argument('testbench_file', nargs='?', help='Path to testbench Verilog file')

    parser.add_argument('--compile-timeout', type=int,
                        default=int(os.environ.get('VERILOG_COMPILE_TIMEOUT', 30)),
                        help='Timeout for compilation in seconds (default: 30)')

    parser.add_argument('--sim-timeout', type=int,
                        default=int(os.environ.get('VERILOG_SIM_TIMEOUT', 60)),
                        help='Timeout for simulation in seconds (default: 60)')

    parser.add_argument('-h', '--help', action='store_true',
                        help='Show this help message and exit')

    args = parser.parse_args()

    # Handle help
    if args.help:
        print_usage()
        sys.exit(0)

    # Validate required arguments
    if not args.dut_file or not args.testbench_file:
        print("Error: Both dut_file and testbench_file are required\n")
        print_usage()
        sys.exit(1)

    # Validate timeout values
    if args.compile_timeout <= 0:
        print("Error: compile-timeout must be positive\n")
        sys.exit(1)

    if args.sim_timeout <= 0:
        print("Error: sim-timeout must be positive\n")
        sys.exit(1)

    return args


def main():
    """Main function"""
    # Parse command-line arguments
    args = parse_arguments()

    dut_file = args.dut_file
    tb_file = args.testbench_file
    compile_timeout = args.compile_timeout
    sim_timeout = args.sim_timeout

    # NEW: Optimize testbench before processing
    optimized_tb_file = optimize_testbench(dut_file, tb_file, compile_timeout, sim_timeout)

    # Process the files (use optimized testbench)
    success = process_files(dut_file, optimized_tb_file, compile_timeout, sim_timeout)

    print(f"\n{'='*60}")
    if success:
        print("✓ SUCCESS: Timing diagram generated")
    else:
        print("✗ FAILED: Could not generate timing diagram")
    print('='*60)

    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
