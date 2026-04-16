#!/usr/bin/env python3
"""
Analyze RTL code using Yosys to extract design information
"""
"""
usage: python3 analyze_rtl.py <rtl_file>
"""
import subprocess
import json
import re
import sys
import tempfile
import os

def run_yosys_command(rtl_file, yosys_script):
    """Run Yosys with a script and return output"""
    try:
        # Create temporary script file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.ys', delete=False) as f:
            f.write(yosys_script)
            script_file = f.name

        # Run Yosys
        result = subprocess.run(
            ['yosys', '-s', script_file],
            capture_output=True,
            text=True,
            timeout=30
        )

        # Clean up
        os.unlink(script_file)

        return result.stdout, result.stderr, result.returncode

    except subprocess.TimeoutExpired:
        print("Error: Yosys command timed out", file=sys.stderr)
        return None, None, -1
    except Exception as e:
        print(f"Error running Yosys: {e}", file=sys.stderr)
        return None, None, -1

def analyze_rtl(rtl_file):
    """Analyze RTL file using Yosys"""

    print("=" * 80)
    print("RTL ANALYSIS USING YOSYS")
    print("=" * 80)
    print(f"\nAnalyzing: {rtl_file}\n")

    # Create Yosys script to extract JSON
    json_file = tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False).name

    yosys_script = f"""
# Read the RTL file
read_verilog -sv -nolatches {rtl_file}

# Run hierarchy check
hierarchy -check

# Process (allow incomplete case statements and latches)
proc -norom

# Write JSON output
write_json {json_file}
"""

    print("Running Yosys analysis...")
    stdout, stderr, returncode = run_yosys_command(rtl_file, yosys_script)

    if returncode != 0:
        print(f"Warning: Yosys returned code {returncode}", file=sys.stderr)
        if stderr:
            print(f"Warning output:\n{stderr}", file=sys.stderr)
        # Continue anyway - JSON might still be generated
        print("Attempting to continue with analysis...\n")

    # Parse JSON output
    try:
        with open(json_file, 'r') as f:
            design = json.load(f)
    except Exception as e:
        print(f"Error reading JSON: {e}", file=sys.stderr)
        return
    finally:
        if os.path.exists(json_file):
            os.unlink(json_file)

    # Extract module information
    modules = design.get('modules', {})

    for module_name, module_data in modules.items():
        print(f"📦 MODULE: {module_name}")
        print("=" * 80)

        # Extract ports
        ports = module_data.get('ports', {})

        inputs = []
        outputs = []
        inouts = []
        clocks = []
        resets = []

        for port_name, port_data in ports.items():
            direction = port_data.get('direction', 'unknown')

            if direction == 'input':
                inputs.append(port_name)
                # Check if it's a clock signal
                if 'clk' in port_name.lower() or port_name.lower() in ['clock', 'c']:
                    clocks.append(port_name)
                # Check if it's a reset signal
                if 'reset' in port_name.lower() or 'rst' in port_name.lower() or port_name.lower() in ['areset', 'aresetn', 'sreset']:
                    resets.append(port_name)
            elif direction == 'output':
                outputs.append(port_name)
            elif direction == 'inout':
                inouts.append(port_name)

        # Print signal information
        print(f"\n📥 INPUT SIGNALS ({len(inputs)}):")
        for sig in sorted(inputs):
            if sig in clocks:
                print(f"  - {sig} [CLOCK]")
            elif sig in resets:
                print(f"  - {sig} [RESET]")
            else:
                print(f"  - {sig}")

        print(f"\n📤 OUTPUT SIGNALS ({len(outputs)}):")
        for sig in sorted(outputs):
            print(f"  - {sig}")

        if inouts:
            print(f"\n🔄 INOUT SIGNALS ({len(inouts)}):")
            for sig in sorted(inouts):
                print(f"  - {sig}")

        print(f"\n⏰ CLOCK SIGNALS ({len(clocks)}):")
        if clocks:
            for sig in clocks:
                print(f"  - {sig}")
        else:
            print("  (None detected)")

        print(f"\n🔄 RESET SIGNALS ({len(resets)}):")
        if resets:
            for sig in resets:
                print(f"  - {sig}")
        else:
            print("  (None detected)")

        # Analyze cells to determine if sequential or combinational
        cells = module_data.get('cells', {})

        sequential_cells = []
        combinational_cells = []

        for cell_name, cell_data in cells.items():
            cell_type = cell_data.get('type', '')

            # Check if it's a flip-flop or latch (sequential element)
            if any(keyword in cell_type.upper() for keyword in ['DFF', 'DFFE', 'DFFSR', 'ADFF', 'SDFF', 'LATCH', 'FF']):
                sequential_cells.append((cell_name, cell_type))
            elif cell_type.startswith('$'):
                # Yosys internal cells
                if any(keyword in cell_type for keyword in ['dff', 'latch', 'dlatch', 'adff', 'sdff']):
                    sequential_cells.append((cell_name, cell_type))
                else:
                    combinational_cells.append((cell_name, cell_type))
            else:
                combinational_cells.append((cell_name, cell_type))

        print(f"\n🔧 CIRCUIT TYPE:")
        if sequential_cells:
            print(f"  ✓ SEQUENTIAL CIRCUIT")
            print(f"    - Sequential elements: {len(sequential_cells)}")
            print(f"    - Combinational cells: {len(combinational_cells)}")
        else:
            print(f"  ✓ COMBINATIONAL CIRCUIT")
            print(f"    - Total cells: {len(combinational_cells)}")

        # Show some sequential elements
        if sequential_cells:
            print(f"\n  Sequential Elements (sample):")
            for i, (cell_name, cell_type) in enumerate(sequential_cells[:5]):
                print(f"    {i+1}. {cell_name}: {cell_type}")
            if len(sequential_cells) > 5:
                print(f"    ... and {len(sequential_cells) - 5} more")

        # Extract statistics from stdout
        print(f"\n📊 STATISTICS:")
        if stdout:
            # Find statistics section
            stat_match = re.search(r'Number of cells:\s+(\d+)', stdout)
            if stat_match:
                print(f"  Total cells: {stat_match.group(1)}")

            wire_match = re.search(r'Number of wires:\s+(\d+)', stdout)
            if wire_match:
                print(f"  Total wires: {wire_match.group(1)}")

        print(f"  Input ports: {len(inputs)}")
        print(f"  Output ports: {len(outputs)}")

        # Summary in structured format
        print("\n" + "=" * 80)
        print("SUMMARY (JSON format)")
        print("=" * 80)

        summary = {
            "module_name": module_name,
            "inputs": sorted(inputs),
            "outputs": sorted(outputs),
            "clocks": clocks,
            "resets": resets,
            "circuit_type": "sequential" if sequential_cells else "combinational",
            "sequential_elements_count": len(sequential_cells),
            "total_cells": len(cells)
        }

        print(json.dumps(summary, indent=2))

    print("\n" + "=" * 80)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 analyze_rtl.py <rtl_file>")
        print("\nExample:")
        print("  python3 analyze_rtl.py module.v")
        print("  python3 analyze_rtl.py design.sv")
        print("\nDescription:")
        print("  Analyzes RTL code using Yosys and extracts:")
        print("  - Input/output signal names")
        print("  - Clock and reset signal names")
        print("  - Circuit type (sequential/combinational)")
        sys.exit(1)

    rtl_file = sys.argv[1]

    if not os.path.exists(rtl_file):
        print(f"Error: File '{rtl_file}' not found", file=sys.stderr)
        sys.exit(1)

    analyze_rtl(rtl_file)
