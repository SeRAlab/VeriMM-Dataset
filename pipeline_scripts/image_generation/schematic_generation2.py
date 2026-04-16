#!/usr/bin/env python3
"""
Verilog to SVG Schematic Generator

This script takes a Verilog file as input and generates an SVG schematic diagram.
It combines the functionality of parsing Verilog and rendering with Graphviz.

Usage:
    python schematic_generation2.py <verilog_file>

Example:
    python schematic_generation2.py design.sv
"""

import sys
import os
import subprocess
import json
import tempfile
from typing import List
from graphviz import Source


class VerilogParser:
    """Parse Verilog files using Yosys to extract module and port information"""

    def __init__(self):
        self.module_name = ""
        self.input_ports = []
        self.output_ports = []

    def parse_verilog_file(self, filename: str) -> bool:
        """Parse a Verilog file using Yosys and extract module information"""
        try:
            # Create a temporary file for JSON output
            with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as json_file:
                json_output_path = json_file.name

            # Create Yosys script
            yosys_script = f"""
read_verilog {filename}
hierarchy -auto-top
proc
write_json {json_output_path}
"""

            # Create temporary script file
            with tempfile.NamedTemporaryFile(mode='w', suffix='.ys', delete=False) as script_file:
                script_file.write(yosys_script)
                script_path = script_file.name

            try:
                # Run Yosys
                result = subprocess.run(
                    ['yosys', '-s', script_path],
                    capture_output=True,
                    text=True,
                    check=True
                )

                # Read the JSON output
                with open(json_output_path, 'r') as f:
                    yosys_data = json.load(f)

                # Extract module information
                modules = yosys_data.get('modules', {})

                if not modules:
                    print("Error: No module found in the file")
                    return False

                # Get the first (top) module
                self.module_name = list(modules.keys())[0]
                module_data = modules[self.module_name]
                ports = module_data.get('ports', {})

                # Extract input and output ports
                self.input_ports = []
                self.output_ports = []

                for port_name, port_info in ports.items():
                    direction = port_info.get('direction')
                    if direction == 'input':
                        self.input_ports.append(port_name)
                    elif direction == 'output':
                        self.output_ports.append(port_name)

                return True

            except subprocess.CalledProcessError as e:
                print(f"Error running Yosys: {e}")
                print(f"Yosys stderr: {e.stderr}")
                return False
            except FileNotFoundError:
                print("Error: Yosys not found. Please ensure Yosys is installed and in your PATH.")
                return False
            finally:
                # Cleanup temporary files
                if os.path.exists(script_path):
                    os.remove(script_path)
                if os.path.exists(json_output_path):
                    os.remove(json_output_path)

        except Exception as e:
            print(f"Error parsing file: {e}")
            return False


class GraphvizGenerator:
    """Generate Graphviz DOT code from parsed Verilog information"""

    def __init__(self, parser: VerilogParser):
        self.parser = parser

    def generate_graphviz_code(self) -> str:
        """Generate Graphviz DOT code from parsed Verilog information"""
        dot_code = []

        # Header
        dot_code.append("digraph G {")
        dot_code.append("    rankdir=LR;")
        dot_code.append("    splines=ortho;")
        dot_code.append("    node [shape=box]; ")

        # Input port connections
        for input_port in self.parser.input_ports:
            dot_code.append(f"    {input_port} -> {self.parser.module_name};")

        # Output port connections
        for output_port in self.parser.output_ports:
            dot_code.append(f"    {self.parser.module_name} -> {output_port};")

        # Module definition
        dot_code.append(f"    {self.parser.module_name} [shape=rect, width=2, height=3];")

        # Port styling (white color)
        all_ports = self.parser.input_ports + self.parser.output_ports
        for port in all_ports:
            dot_code.append(f'    {port} [color="white"];')

        # Footer
        dot_code.append("}")

        return '\n'.join(dot_code)


class SchematicGenerator:
    """Main class to orchestrate the Verilog to SVG conversion"""

    def __init__(self, verilog_file: str):
        self.verilog_file = verilog_file
        self.parser = VerilogParser()
        self.dot_file = None
        self.svg_file = None

    def generate(self) -> bool:
        """Generate SVG schematic from Verilog file"""
        # Step 1: Parse Verilog file
        print(f"Parsing Verilog file: {self.verilog_file}")
        if not self.parser.parse_verilog_file(self.verilog_file):
            return False

        print(f"Module: {self.parser.module_name}")
        print(f"Inputs: {', '.join(self.parser.input_ports)}")
        print(f"Outputs: {', '.join(self.parser.output_ports)}")

        # Step 2: Generate Graphviz DOT code
        print("\nGenerating Graphviz DOT code...")
        generator = GraphvizGenerator(self.parser)
        graphviz_code = generator.generate_graphviz_code()

        # Step 3: Write temporary DOT file
        self.dot_file = f"{self.parser.module_name}_graph.dot"
        try:
            with open(self.dot_file, 'w') as file:
                file.write(graphviz_code)
            print(f"DOT file created: {self.dot_file}")
        except Exception as e:
            print(f"Error writing DOT file: {e}")
            return False

        # Step 4: Render SVG using Graphviz
        print("\nRendering SVG schematic...")
        try:
            source = Source(graphviz_code)
            output_name = f"{self.parser.module_name}_graph"
            source.render(filename=output_name, format='svg', cleanup=True, directory='.')
            self.svg_file = f"{output_name}.svg"
            print(f"SVG schematic generated: {self.svg_file}")
        except Exception as e:
            print(f"Error rendering SVG: {e}")
            self.cleanup()
            return False

        # Step 5: Cleanup intermediate files
        self.cleanup()

        return True

    def cleanup(self):
        """Remove intermediate DOT files"""
        if self.dot_file and os.path.exists(self.dot_file):
            try:
                os.remove(self.dot_file)
                print(f"Cleaned up intermediate file: {self.dot_file}")
            except Exception as e:
                print(f"Warning: Could not remove {self.dot_file}: {e}")


def main():
    """Main entry point"""
    if len(sys.argv) != 2:
        print("Usage: python schematic_generation2.py <verilog_file>")
        print("Example: python schematic_generation2.py design.sv")
        sys.exit(1)

    verilog_file = sys.argv[1]

    # Check if file exists
    if not os.path.exists(verilog_file):
        print(f"Error: File '{verilog_file}' not found")
        sys.exit(1)

    # Generate schematic
    generator = SchematicGenerator(verilog_file)
    if generator.generate():
        print("\n" + "="*50)
        print(f"SUCCESS! SVG schematic saved as: {generator.svg_file}")
        print("="*50)
        sys.exit(0)
    else:
        print("\nERROR: Failed to generate schematic")
        sys.exit(1)


if __name__ == "__main__":
    main()
