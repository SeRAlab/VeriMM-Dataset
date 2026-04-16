"""
Generate an SVG picture from a Verilog netlist by converting it to JSON, modifying the JSON,
and then converting it to SVG.

Example: python schematic_generation1.py simple_dff.v [-o output_directory]
"""


import json
import subprocess
import argparse
import os
import sys



def modify_netlist_json(input_file, output_file):
    """
    Modify a netlist JSON file by adding port_directions to cells.

    Args:
        input_file: Path to input JSON file
        output_file: Path to output JSON file

    Rules:
        - For cells without port_directions, add them (default all ports as input)
        - For cells with type "dff", change type to "$dff" and set port_directions
          to {"CLK": "input", "D": "input", "Q": "output"}
    """
    # Load the JSON file
    with open(input_file, 'r') as f:
        data = json.load(f)

    # Process each module
    if 'modules' in data:
        for module_name, module_data in data['modules'].items():
            # Process each cell in the module
            if 'cells' in module_data:
                for cell_name, cell_data in module_data['cells'].items():
                    # Check if it's a dff module
                    if cell_data.get('type') == 'dff':
                        # Change type to $dff
                        cell_data['type'] = '$dff'
                        # Set port directions like dff_a
                        cell_data['port_directions'] = {
                            'CLK': 'input',
                            'D': 'input',
                            'Q': 'output'
                        }
                    # If port_directions doesn't exist, add it
                    elif 'port_directions' not in cell_data:
                        # Get port names from connections
                        if 'connections' in cell_data:
                            port_directions = {}
                            for port_name in cell_data['connections'].keys():
                                # Default all ports to input
                                port_directions[port_name] = 'input'
                            cell_data['port_directions'] = port_directions

    # Write the modified JSON to output file
    with open(output_file, 'w') as f:
        json.dump(data, f, indent=2)

    print(f"Modified JSON saved to {output_file}")


def run_yosys(verilog_file, output_json):
    """
    Run yowasp-yosys to convert Verilog to JSON.

    Args:
        verilog_file: Path to input Verilog file
        output_json: Path to output JSON file
    """
    # Extract the filename without path for the command
    verilog_filename = os.path.basename(verilog_file)

    # Build the yosys command
    yosys_cmd = [
        'yowasp-yosys',
        '-p',
        f'read_verilog -sv {verilog_filename}; hierarchy -auto-top; proc; write_json {output_json}; stat'
        
    ]

    print(f"Running yosys: {' '.join(yosys_cmd)}")

    # Run yosys command in the directory containing the verilog file
    work_dir = os.path.dirname(os.path.abspath(verilog_file)) or '.'

    try:
        result = subprocess.run(yosys_cmd, cwd=work_dir, check=True,
                              capture_output=True, text=True)
        print("Yosys completed successfully")
        print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running yosys: {e}")
        print(f"stdout: {e.stdout}")
        print(f"stderr: {e.stderr}")
        return False


def run_netlistsvg(input_json, output_svg):
    """
    Run netlistsvg to convert JSON to SVG.

    Args:
        input_json: Path to input JSON file
        output_svg: Path to output SVG file
    """
    # Build the netlistsvg command
    netlistsvg_cmd = ['netlistsvg', input_json, '-o', output_svg]

    print(f"Running netlistsvg: {' '.join(netlistsvg_cmd)}")

    try:
        result = subprocess.run(netlistsvg_cmd, check=True,
                              capture_output=True, text=True)
        print(f"SVG generated successfully: {output_svg}")
        print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running netlistsvg: {e}")
        print(f"stdout: {e.stdout}")
        print(f"stderr: {e.stderr}")
        return False


def check_json_validity(json_file):
    """
    Check if the JSON file has only one module with more than 10 cells.
    If so, exit the script with code 2.

    Args:
        json_file: Path to the JSON file to check
    """
    with open(json_file, 'r') as f:
        data = json.load(f)

    # Check if there's a modules section
    if 'modules' in data:
        modules = data['modules']

        # Check if there's only one module
        if len(modules) == 1:
            # Get the single module
            module_name = list(modules.keys())[0]
            module_data = modules[module_name]

            # Check if it has cells
            if 'cells' in module_data:
                num_cells = len(module_data['cells'])

                # If more than 8 cells, exit with code 2
                if num_cells > 8:
                    print(f"Error: Module '{module_name}' has {num_cells} cells (more than 8)")
                    return 0
                    # sys.exit(2)
    print("JSON validity check passed")
    return 1


def process_verilog_to_svg(verilog_file, output_dir=None):
    """
    Complete pipeline: Verilog -> JSON -> Modified JSON -> SVG

    Args:
        verilog_file: Path to input Verilog file
        output_dir: Directory for output files (default: same as input file)
    """
    # Determine output directory
    if output_dir is None:
        output_dir = os.path.dirname(os.path.abspath(verilog_file)) or '.'

    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    # Generate filenames
    base_name = os.path.splitext(os.path.basename(verilog_file))[0]
    temp_json = os.path.join(output_dir, f'{base_name}_temp.json')
    modified_json = os.path.join(output_dir, f'{base_name}_modified.json')
    output_svg = os.path.join(output_dir, f'{base_name}_graph.svg')

    # Step 1: Run yosys to generate JSON
    print("\n=== Step 1: Converting Verilog to JSON ===")
    if not run_yosys(verilog_file, os.path.basename(temp_json)):
        print("Failed to convert Verilog to JSON")
        sys.exit(1)

    # Step 2: Modify the JSON
    print("\n=== Step 2: Modifying JSON ===")
    try:
        modify_netlist_json(temp_json, modified_json)
    except Exception as e:
        print(f"Failed to modify JSON: {e}")
        sys.exit(1)

    # Check JSON validity before proceeding
    check_result=check_json_validity(temp_json)

    # Step 3: Generate SVG from modified JSON
    print("\n=== Step 3: Generating SVG ===")
    if check_result==1:
        if not run_netlistsvg(modified_json, output_svg):
            print("Failed to generate SVG")
            sys.exit(1)
    else:
        print("Skipping netlist SVG generation due to the complexity of the design.")

    #delete temporary JSON file and modified JSON file
    try:
        os.remove(temp_json)
        os.remove(modified_json)
    except OSError as e:
        print(f"Error deleting temporary file {temp_json} or modified file {modified_json}: {e}")

    if check_result==1:
        print(f"\n=== Pipeline completed successfully! ===")
        print(f"Modified JSON: {modified_json}")
        print(f"Output SVG: {output_svg}")
    else:
        print("skipped SVG generation due to complexity of the design.")
        sys.exit(2)



if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Convert Verilog to SVG via JSON netlist with modifications'
    )
    parser.add_argument('verilog_file', help='Input Verilog file')
    parser.add_argument('-o', '--output-dir',
                       help='Output directory (default: same as input file)',
                       default=None)

    args = parser.parse_args()

    # Check if input file exists
    if not os.path.exists(args.verilog_file):
        print(f"Error: Input file '{args.verilog_file}' does not exist")
        sys.exit(1)

    # Run the complete pipeline
    process_verilog_to_svg(args.verilog_file, args.output_dir)

