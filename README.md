# VeriMM-Dataset

A large-scale Verilog dataset for multimodal hardware design understanding including the full automated construction pipeline. The dataset contains **57,304** Verilog design samples with natural language descriptions, RTL code, testbenches, circuit metadata, and corresponding circuit diagram images (schematics, waveforms, and FSM diagrams).

## Dataset Statistics

| Category | Count |
|---|---|
| Total annotated samples | 57,304 |
| Sequential circuits | 33,846 |
| Combinational circuits | 23,458 |
| Schematic diagrams | 45,351 |
| Waveform diagrams | 18,224 |
| FSM diagrams | 2,140 |

## Repository Structure

```
VeriMM-Dataset/
├── annotations/                # JSONL files with design annotations
│   ├── chunk_1.jsonl
│   ├── chunk_2.jsonl
│   └── ...                     # 200 chunk files, ~57K entries total
├── images/                     # Circuit diagram images
│   ├── <hash_prefix>/          # Two-character hex prefix (00-c9)
│   │   └── <sample_id>/        # Per-sample directory
│   │       ├── code.v                # Verilog source code
│   │       ├── testbench.v           # Testbench code
│   │       ├── spec.txt              # Design specification
│   │       ├── schematic.png         # Circuit schematic diagram
│   │       ├── waveform.png          # Simulation waveform (if applicable)
│   │       └── fsm.png               # FSM state diagram (if applicable)
│   └── ...
├── pipeline_scripts/           # Scripts used to build the dataset
│   ├── data_preprocessing/     # Data cleaning and annotation
│   │   ├── deduplicate.py            # Semantic deduplication using FAISS
│   │   ├── syntax_check.py           # Verilog syntax validation (iverilog/Yosys)
│   │   ├── tag_circuit_type.py       # Label circuits as sequential/combinational
│   │   └── tag_hierarchy.py          # Compute module hierarchy depth via Yosys
│   ├── image_generation/       # Circuit diagram rendering
│   │   ├── fsm_generation.py         # FSM diagram generation using Verdi and Graphviz
│   │   ├── schematic_generation1.py  # Schematic generation via netlist JSON to SVG
│   │   ├── schematic_generation2.py  # Schematic generation via Yosys and Graphviz
│   │   ├── timing_diagram_generation.py  # Waveform rendering from VCD simulation
│   │   └── vcd2wavedrom.py           # VCD to WaveDrom JSON converter
│   └── testbench_generation/   # Automated testbench creation
│       ├── analyze_rtl.py            # RTL analysis using Yosys
│       ├── coverage_gap_report.py    # Coverage gap reporting via URG
│       ├── insert_testcases.py       # Insert generated testcases into testbench templates
│       ├── tb_pipeline_iter.py       # Iterative coverage-driven testbench generation pipeline
│       └── template_generation.py    # Testbench template generator
└── README.md
```

## Annotation Format

Each line in the JSONL files is a JSON object with the following fields:

| Field | Type | Description |
|---|---|---|
| `description` | string | Natural language description of the circuit's intended functionality |
| `code` | string | Verilog RTL source code implementing the design |
| `testbench` | string | Verilog testbench for simulation and verification |
| `circuit_hierarchy` | integer | Module hierarchy depth (1 = single module, higher = deeper nesting) |
| `type` | string | Circuit type: `"sequential"` or `"combinational"` |

### Example Entry

```json
{
  "description": "Design a simple PCIe request-response controller that handles incoming requests and generates appropriate responses...",
  "code": "module pcie_controller ( ... );  ...",
  "circuit_hierarchy": 1,
  "type": "sequential",
  "testbench": "`timescale 1ns/1ps ..."
}
```

## Image Data

The `images/` directory organizes samples into subdirectories using a two-level hash-based structure (`<prefix>/<sample_id>/`). Each sample directory may contain:

- **schematic.png** -- Circuit schematic diagram showing the gate-level or RTL-level structure
- **waveform.png** -- Simulation waveform showing signal transitions over time
- **fsm.png** -- Finite state machine diagram (present only for sequential designs with explicit FSMs)
- **code.v / testbench.v / spec.txt** -- Source files used to generate the diagrams

## Circuit Hierarchy Distribution

| Hierarchy Depth | Count |
|---|---|
| 1 (single module) | 57,145 |
| 2 | 144 |
| 3 | 4 |
| 5 | 3 |
| 6 | 7 |
| 7 | 1 |

## Usage

Load the annotations in Python:

```python
import json

samples = []
for i in range(1, 201):
    with open(f"annotations/chunk_{i}.jsonl") as f:
        for line in f:
            samples.append(json.loads(line))

print(f"Loaded {len(samples)} samples")
```

## License

Please refer to the LICENSE file for usage terms.