#!/usr/bin/env python3
"""
Testbench Template Generator
Automatically detects sequential/combinational circuits and generates appropriate testbench templates
"""
"""
usage: python generate_testbench.py <verilog_file> [output_file]
"""
import re
import sys
import os
from pathlib import Path


def is_sequential_circuit(file_path):
    """
    Detect if a Verilog design is sequential by checking for posedge/negedge.
    Returns True if sequential, False if combinational.
    """
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove comments to avoid false positives
    content = re.sub(r'//.*', '', content)
    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)

    # Check for posedge or negedge keywords
    if re.search(r'\b(posedge|negedge)\b', content, re.IGNORECASE):
        return True

    return False


def extract_clock_signals(file_path):
    """
    Extract clock signal names by finding signals used with posedge/negedge.
    Returns: set of clock signal names
    """
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove comments to avoid false positives
    content = re.sub(r'//.*', '', content)
    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)

    # Find all posedge/negedge statements and extract the signal name
    # Matches: posedge signal_name or negedge signal_name
    clock_signals = set()
    pattern = r'\b(posedge|negedge)\s+(\w+)'
    matches = re.findall(pattern, content, re.IGNORECASE)

    for edge_type, signal_name in matches:
        clock_signals.add(signal_name)

    return clock_signals


def parse_verilog_module(file_path):
    """
    Parse a Verilog/SystemVerilog file to extract module information.
    Supports both Verilog-2001 (inline) and Verilog-1995 (separate) port declarations.
    Returns: dict with module_name, inputs, outputs
    """
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove comments
    content_no_comments = re.sub(r'//.*', '', content)
    content_no_comments = re.sub(r'/\*.*?\*/', '', content_no_comments, flags=re.DOTALL)

    # Find module declaration
    module_match = re.search(r'module\s+(\w+)\s*(?:#\s*\([^)]*\))?\s*\((.*?)\);',
                            content_no_comments, re.DOTALL)

    if not module_match:
        raise ValueError("Could not find module declaration")

    module_name = module_match.group(1)
    ports_section = module_match.group(2)

    # Parse ports
    inputs = []
    outputs = []

    # Try Verilog-2001 style first (inline declarations)
    # Split by comma, handling multi-line declarations
    port_lines = ports_section.split(',')

    inline_parsed = False
    for line in port_lines:
        line = line.strip()
        if not line:
            continue

        # Match input/output declarations
        # Supports: input [width-1:0] name, input name, output reg [width-1:0] name, etc.
        port_match = re.search(r'(input|output)\s+(?:(wire|reg|logic)\s+)?(?:\[([^\]]+)\]\s+)?(\w+)', line)

        if port_match:
            inline_parsed = True
            direction = port_match.group(1)
            width_spec = port_match.group(3)
            port_name = port_match.group(4)

            # Determine bit width
            if width_spec:
                # Parse width like "7:0" or "WIDTH-1:0"
                width = width_spec
            else:
                width = None  # Single bit

            port_info = {
                'name': port_name,
                'width': width
            }

            if direction == 'input':
                inputs.append(port_info)
            else:
                outputs.append(port_info)

    # If no inline declarations found, try Verilog-1995 style (separate declarations)
    if not inline_parsed:
        # Extract port names from module declaration
        port_names = [p.strip() for p in ports_section.split(',') if p.strip()]

        # Find input/output declarations in the module body
        # Match patterns like: input A, B, C; or output reg [7:0] Q;
        input_pattern = r'input\s+(?:(wire|reg|logic)\s+)?(?:\[([^\]]+)\]\s+)?([^;]+);'
        output_pattern = r'output\s+(?:(wire|reg|logic)\s+)?(?:\[([^\]]+)\]\s+)?([^;]+);'

        # Find all input declarations
        for match in re.finditer(input_pattern, content_no_comments):
            wire_type = match.group(1)
            width_spec = match.group(2)
            names_str = match.group(3)

            # Parse multiple comma-separated names
            names = [n.strip() for n in names_str.split(',')]

            for name in names:
                if name in port_names:
                    port_info = {
                        'name': name,
                        'width': width_spec
                    }
                    inputs.append(port_info)

        # Find all output declarations
        for match in re.finditer(output_pattern, content_no_comments):
            wire_type = match.group(1)
            width_spec = match.group(2)
            names_str = match.group(3)

            # Parse multiple comma-separated names
            names = [n.strip() for n in names_str.split(',')]

            for name in names:
                if name in port_names:
                    port_info = {
                        'name': name,
                        'width': width_spec
                    }
                    outputs.append(port_info)

    return {
        'module_name': module_name,
        'inputs': inputs,
        'outputs': outputs
    }


def generate_testbench(module_info, is_sequential, input_file, output_file=None):
    """
    Generate testbench template from module information.
    """
    module_name = module_info['module_name']
    inputs = module_info['inputs']
    outputs = module_info['outputs']

    # Determine if there's a clock signal (for sequential circuits)
    clk_signal = None
    if is_sequential:
        # Extract clock signals from posedge/negedge statements
        clock_signals = extract_clock_signals(input_file)

        # Find which clock signal is in the inputs
        for inp in inputs:
            if inp['name'] in clock_signals:
                clk_signal = inp['name']
                break

    # Build the testbench content
    tb_name = f"{module_name}_tb"

    lines = []

    # Timescale
    lines.append("`timescale 1ns/1ps")
    lines.append("")

    # Module declaration
    lines.append(f"module {tb_name};")
    lines.append("")

    # Signal declarations
    circuit_type = "sequential" if is_sequential else "combinational"
    lines.append(f"    // Testbench signals ({circuit_type} circuit)")

    # Input signals (reg)
    for inp in inputs:
        if inp['width']:
            lines.append(f"    reg [{inp['width']}] {inp['name']};")
        else:
            lines.append(f"    reg {inp['name']};")

    # Output signals (wire)
    for out in outputs:
        if out['width']:
            lines.append(f"    wire [{out['width']}] {out['name']};")
        else:
            lines.append(f"    wire {out['name']};")

    lines.append("")

    # Test tracking variables
    lines.append("    // Test tracking")
    lines.append("    integer test_num;")
    lines.append("    integer pass_count;")
    lines.append("    integer fail_count;")
    lines.append("")

    # DUT instantiation
    lines.append("    // Instantiate the DUT (Device Under Test)")
    lines.append(f"    {module_name} dut (")

    port_connections = []
    for inp in inputs:
        port_connections.append(f"        .{inp['name']}({inp['name']})")
    for out in outputs:
        port_connections.append(f"        .{out['name']}({out['name']})")

    lines.append(",\n".join(port_connections))
    lines.append("    );")
    lines.append("")

    # Clock generation (only for sequential circuits)
    if is_sequential and clk_signal:
        lines.append("    // Clock generation (10ns period)")
        lines.append("    initial begin")
        lines.append(f"        {clk_signal} = 0;")
        lines.append(f"        forever #5 {clk_signal} = ~{clk_signal};")
        lines.append("    end")
        lines.append("")

    # Reset task (only for sequential circuits)
    if is_sequential:
        lines.append("    task reset_dut;")
        lines.append("    //define reset task")
        lines.append("    endtask")
        lines.append("")

    # Test case task
    lines.append("    task testcases1;")
    if is_sequential:
        lines.append("    reset_dut();")
    lines.append("    //define test cases1")
    lines.append("    endtask")
    lines.append("")
    lines.append("    task testcases2;")
    if is_sequential:
        lines.append("    reset_dut();")
    lines.append("    //define test cases2")
    lines.append("    endtask")
    lines.append("    //define other testcases here")

    lines.append("")
    lines.append("")

    # Test stimulus
    lines.append("    // Test stimulus")
    lines.append("    initial begin")
    lines.append("        // Initialize")
    lines.append("        test_num = 0;")
    lines.append("        pass_count = 0;")
    lines.append("        fail_count = 0;")
    lines.append("")
    lines.append('        $display("========================================");')
    lines.append(f'        $display("{module_name} Testbench");')
    lines.append('        $display("========================================");')
    lines.append("")
    lines.append("")
    lines.append("        testcases1();")
    lines.append("        testcases2();")
    lines.append("        // Call other test case tasks here")
    lines.append("        ")
    lines.append("")
    lines.append("        // Print summary")
    lines.append('        $display("\\n========================================");')
    lines.append('        $display("Test Summary");')
    lines.append('        $display("========================================");')
    lines.append('        $display("Tests Passed: %0d", pass_count);')
    lines.append('        $display("Tests Failed: %0d", fail_count);')
    lines.append('        $display("Total Tests:  %0d", pass_count + fail_count);')
    lines.append('        $display("========================================");')
    lines.append("")
    lines.append("        if (fail_count == 0)")
    lines.append('            $display("ALL TESTS PASSED!");')
    lines.append("        else")
    lines.append('            $display("SOME TESTS FAILED!");')
    lines.append("")
    lines.append('        $display("\\nSimulation completed at time %0t", $time);')
    lines.append("        $finish;")
    lines.append("    end")
    lines.append("")

    # check_outputs task
    lines.append("    // Task to check outputs")
    lines.append("    task check_outputs;")

    # Task inputs for expected values
    for out in outputs:
        if out['width']:
            lines.append(f"        input [{out['width']}] expected_{out['name']};")
        else:
            lines.append(f"        input expected_{out['name']};")

    lines.append("        begin")

    # Add delay for combinational circuits to allow logic to settle
    if not is_sequential:
        lines.append("            #1; // Small delay for combinational logic to settle")

    # Build comparison condition
    comparisons = []
    for out in outputs:
       comparisons.append(f"expected_{out['name']} === (expected_{out['name']} ^ {out['name']} ^ expected_{out['name']})")

    condition = " &&\n                ".join(comparisons)

    lines.append(f"            if ({condition}) begin")
    lines.append('                $display("PASS");')

    # Build output display
    output_format = ", ".join([f"{out['name']}=%b" if not out['width'] else f"{out['name']}=%h" for out in outputs])
    output_vars = ", ".join([out['name'] for out in outputs])

    lines.append(f'                $display("  Outputs: {output_format}",')
    lines.append(f'                         {output_vars});')
    lines.append("                pass_count = pass_count + 1;")
    lines.append("            end else begin")
    lines.append('                $display("FAIL");')

    # Expected output display
    expected_vars = ", ".join([f"expected_{out['name']}" for out in outputs])
    lines.append(f'                $display("  Expected: {output_format}",')
    lines.append(f'                         {expected_vars});')

    # Got output display
    lines.append(f'                $display("  Got:      {output_format}",')
    lines.append(f'                         {output_vars});')
    lines.append("                fail_count = fail_count + 1;")
    lines.append("            end")
    lines.append("        end")
    lines.append("    endtask")
    lines.append("")

    # Timeout watchdog
    lines.append("    // Timeout watchdog")
    lines.append("    initial begin")
    lines.append("        #1000000; // 1ms timeout")
    lines.append('        $display("\\nERROR: Simulation timeout!");')
    lines.append("        $finish;")
    lines.append("    end")
    lines.append("")

    # Waveform dump
    if is_sequential:
        all_signal_string=", ".join([sig['name'] for sig in inputs + outputs])
        lines.append("    // Optional: Waveform dump for debugging")
        lines.append("    initial begin")
        lines.append(f'        $dumpfile("wave.vcd");')
        lines.append(f"        $dumpvars(0,{all_signal_string});")
        lines.append("    end")
        lines.append("")

    lines.append("endmodule")
    lines.append("")

    testbench_content = "\n".join(lines)

    # Write to file if specified
    if output_file:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(testbench_content)
        print(f"Testbench generated: {output_file}")

    return testbench_content


def main():
    """Main function to handle command-line usage."""
    if len(sys.argv) < 2:
        print("Usage: python generate_testbench.py <verilog_file> [output_file]")
        print("\nExample:")
        print('  python generate_testbench.py module.sv')
        print('  python generate_testbench.py module.sv module_tb.v')
        sys.exit(1)

    input_file = sys.argv[1]

    # Check if file exists
    if not os.path.exists(input_file):
        print(f"Error: File '{input_file}' not found")
        sys.exit(1)

    # Determine output file
    if len(sys.argv) >= 3:
        output_file = sys.argv[2]
    else:
        # Auto-generate output filename
        base_name = Path(input_file).stem
        output_file = f"{base_name}_tb.v"

    try:
        print(f"Parsing module from: {input_file}")

        # Detect circuit type
        is_sequential = is_sequential_circuit(input_file)
        circuit_type = "sequential" if is_sequential else "combinational"
        print(f"Detected circuit type: {circuit_type}")

        # Parse module
        module_info = parse_verilog_module(input_file)

        print(f"Module name: {module_info['module_name']}")
        print(f"Inputs: {len(module_info['inputs'])}")
        print(f"Outputs: {len(module_info['outputs'])}")
        print()

        # Generate testbench with appropriate structure
        testbench = generate_testbench(module_info, is_sequential, input_file, output_file)

        print("Testbench template generated successfully!")

    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
