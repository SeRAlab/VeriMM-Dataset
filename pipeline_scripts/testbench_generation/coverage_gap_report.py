#!/usr/bin/env python3
"""Run the existing Makefile (find/com/sim/cov) and summarize uncovered items.

The script shells out to the local Makefile targets (`clean`, `find`, `com`,
`sim`, `cov`) to build the design, run the coverage-enabled simulation, and
generate a URG text report.  It then parses `cov_report/modinfo.txt` to list
uncovered lines, FSM transitions, and toggle bits for the requested DUT module.
"""

from __future__ import annotations

import argparse
import pathlib
import re
import subprocess
import sys
from typing import Iterable, List, Sequence, Tuple


def run_cmd(cmd: Sequence[str], cwd: pathlib.Path) -> None:
    """Run a shell command and stream its output."""

    print("[cmd]", " ".join(cmd))
    subprocess.run(cmd, cwd=str(cwd), check=True)


def run_make_target(make_cmd: Sequence[str], target: str, cwd: pathlib.Path, extra: Sequence[str] = ()) -> None:
    cmd = list(make_cmd) + [target, *extra]
    run_cmd(cmd, cwd)


def cleanup_logs(project_dir: pathlib.Path) -> None:
    """Remove previous run log files."""
    log_patterns = ["*.log", "*.vpd", "*.key", "*race.out*", "*profileReport*", "*simprofile*"]

    for pattern in log_patterns:
        for log_file in project_dir.glob(pattern):
            if log_file.is_file():
                try:
                    log_file.unlink()
                    print(f"[cleanup] Removed {log_file.name}")
                except Exception as e:
                    print(f"[cleanup] Warning: Could not remove {log_file.name}: {e}")


def create_file_list(dut_path: pathlib.Path, tb_path: pathlib.Path, project_dir: pathlib.Path) -> None:
    """Create file_list with DUT and testbench files."""
    file_list_path = project_dir / "file_list"

    # Convert to relative paths if they're under project_dir, otherwise use absolute paths
    try:
        dut_relative = dut_path.resolve().relative_to(project_dir)
        dut_str = f"./{dut_relative}"
    except ValueError:
        dut_str = str(dut_path.resolve())

    try:
        tb_relative = tb_path.resolve().relative_to(project_dir)
        tb_str = f"./{tb_relative}"
    except ValueError:
        tb_str = str(tb_path.resolve())

    with file_list_path.open("w") as f:
        f.write(f"{dut_str}\n")
        f.write(f"{tb_str}\n")

    print(f"[file_list] Created with {dut_path.name} and {tb_path.name}")


def guess_module_name(verilog_path: pathlib.Path) -> str:
    module_re = re.compile(r"^\s*module\s+([a-zA-Z_][\w$]*)")
    for line in verilog_path.read_text().splitlines():
        match = module_re.match(line)
        if match:
            return match.group(1)
    raise ValueError("Unable to detect a module name; please pass --module explicitly")


def extract_section(lines: List[str], start_token: str, end_tokens: Iterable[str]) -> List[str]:
    """Return a slice of lines between start_token and the earliest end_token."""

    start = None
    for idx, line in enumerate(lines):
        if start_token in line:
            start = idx
            break
    if start is None:
        raise ValueError(f"Unable to find section labeled '{start_token}'")

    end = len(lines)
    for idx in range(start + 1, len(lines)):
        if any(token in lines[idx] for token in end_tokens):
            end = idx
            break
    return lines[start:end]


def try_extract_section(lines: List[str], start_token: str, end_tokens: Iterable[str]) -> List[str]:
    try:
        return extract_section(lines, start_token, end_tokens)
    except ValueError:
        return []


def get_module_block(modinfo_path: pathlib.Path, module_name: str) -> List[str]:
    lines = modinfo_path.read_text().splitlines()
    start = None
    for idx, line in enumerate(lines):
        if line.startswith("Module :"):
            name = line.split(":", 1)[1].strip()
            if name == module_name:
                start = idx
                break
    if start is None:
        raise ValueError(f"Module '{module_name}' not found in {modinfo_path}")

    for idx in range(start + 1, len(lines)):
        if lines[idx].startswith("Module :"):
            return lines[start:idx]
    return lines[start:]


def parse_line_gaps(section: List[str]) -> List[Tuple[int, int, int, str]]:
    uncovered: List[Tuple[int, int, int, str]] = []
    pattern = re.compile(r"^\s*(\d+)\s+(\d+)/(\d+)")
    for line in section:
        match = pattern.match(line)
        if not match:
            continue
        line_no = int(match.group(1))
        covered = int(match.group(2))
        total = int(match.group(3))
        if covered >= total:
            continue
        snippet = line[match.end():].strip()
        uncovered.append((line_no, covered, total, snippet))
    return uncovered


def parse_toggle_gaps(section: List[str]) -> List[str]:
    gaps: List[str] = []
    current = None
    skip_tokens = {
        "Totals",
        "Ports",
        "Signals",
        "Total Bits",
        "Port Bits",
        "Signal Bits",
    }
    for line in section:
        stripped = line.strip()
        if not stripped:
            continue
        if stripped.startswith("Port Details"):
            current = "port"
            continue
        if stripped.startswith("Signal Details"):
            current = "signal"
            continue
        if stripped.startswith("-------------------------------------------------------------------------------"):
            current = None
            continue
        if current is None:
            continue
        # Split by any whitespace (1 or more spaces) to handle varying spacing
        cols = re.split(r"\s+", stripped)
        if not cols or cols[0] in skip_tokens:
            continue
        if current == "port" and len(cols) >= 5:
            name, toggle, down, up, direction = cols[:5]
            missing: List[str] = []
            if toggle.lower() == "no":
                missing.append("overall toggle")
            if down.lower() == "no":
                missing.append("1->0")
            if up.lower() == "no":
                missing.append("0->1")
            if missing:
                gaps.append(f"Port {name} ({direction}) missing: {', '.join(missing)}")
        elif current == "signal" and len(cols) >= 4:
            name, toggle, down, up = cols[:4]
            missing = []
            if toggle.lower() == "no":
                missing.append("overall toggle")
            if down.lower() == "no":
                missing.append("1->0")
            if up.lower() == "no":
                missing.append("0->1")
            if missing:
                gaps.append(f"Signal {name} missing: {', '.join(missing)}")
    return gaps


def parse_fsm_gaps(section: List[str]) -> List[Tuple[str, int]]:
    gaps: List[Tuple[str, int]] = []
    mode = None
    pattern = re.compile(r"^\s*([^\s]+)\s+(\d+)\s+(.*)$")
    for line in section:
        stripped = line.strip()
        if stripped.startswith("transitions"):
            mode = "transitions"
            continue
        if stripped.startswith("Sequences"):
            mode = None
            continue
        if not stripped or stripped.startswith("states"):
            continue
        if mode != "transitions":
            continue
        match = pattern.match(line)
        if not match:
            continue
        target = match.group(1)
        line_no = int(match.group(2))
        status = match.group(3)
        if "Not Covered" in status:
            gaps.append((target, line_no))
    return gaps


def parse_cond_gaps(section: List[str]) -> List[Tuple[int, str, str]]:
    gaps: List[Tuple[int, str, str]] = []
    i = 0
    while i < len(section):
        line = section[i].strip()
        if not line:
            i += 1
            continue
        if line.startswith("LINE"):
            parts = line.split()
            try:
                line_no = int(parts[1])
            except (IndexError, ValueError):
                i += 1
                continue
            i += 1
            expr = ""
            # Handle both EXPRESSION and SUB-EXPRESSION
            if i < len(section):
                stripped = section[i].strip()
                if stripped.startswith("EXPRESSION"):
                    expr = section[i].split("EXPRESSION", 1)[1].strip()
                    i += 1
                elif stripped.startswith("SUB-EXPRESSION"):
                    expr = section[i].split("SUB-EXPRESSION", 1)[1].strip()
                    i += 1
            while i < len(section) and "Status" not in section[i]:
                i += 1
            if i >= len(section):
                break
            i += 1  # skip header
            while i < len(section):
                row = section[i]
                if not row.strip():
                    break
                if "Status" in row and row.strip().endswith("Status"):
                    i += 1
                    continue
                if "Not Covered" in row:
                    combo = row.split("Not Covered")[0].rstrip()
                    combo = re.sub(r"\s+", " ", combo).strip()
                    gaps.append((line_no, expr, combo or "<combination unspecified>"))
                i += 1
        else:
            i += 1
    return gaps


def parse_branch_gaps(section: List[str]) -> List[Tuple[int, str, str]]:
    gaps: List[Tuple[int, str, str]] = []

    i = 0
    while i < len(section):
        raw = section[i]

        # Track lines with line numbers and build local marker map for each section
        section_start_line = None
        section_end_line = None
        branch_marker_to_line: dict[int, int] = {}

        # Look for the start of a code section (line with line number)
        line_match = re.match(r"^\s*(\d+)\s+(.*\S)", raw)
        if line_match:
            section_start_line = int(line_match.group(1))
            section_end_line = section_start_line

            # Scan forward to build marker mapping until we hit "Branches:"
            j = i
            current_line_num = None
            while j < len(section) and not section[j].strip().startswith("Branches:"):
                line_match_inner = re.match(r"^\s*(\d+)\s+(.*\S)", section[j])
                if line_match_inner:
                    current_line_num = int(line_match_inner.group(1))
                    section_end_line = current_line_num
                else:
                    # Check for branch markers (may have multiple markers on one line)
                    markers_found = re.findall(r"-(\d+)-", section[j])
                    if markers_found and current_line_num is not None:
                        for marker_str in markers_found:
                            marker_num = int(marker_str)
                            branch_marker_to_line[marker_num] = current_line_num
                j += 1

            # Now process the Branches: table if we found one
            if j < len(section) and section[j].strip().startswith("Branches:"):
                i = j + 1  # Move past "Branches:"

                # Skip to Status header
                while i < len(section) and "Status" not in section[i]:
                    i += 1
                if i >= len(section):
                    break
                i += 1  # skip Status header

                # Process each row in the branch table
                while i < len(section):
                    row = section[i]
                    if not row.strip():
                        break
                    if "Not Covered" in row:
                        # Parse the row
                        parts = row.split("Not Covered")[0].split()
                        if len(parts) >= 1:
                            state_or_cond = parts[0]
                            branch_values = parts[1:] if len(parts) > 1 else []

                            # Find which branch markers have non-dash values (indicating they're involved)
                            # Note: branch_values[0] corresponds to marker -2-, branch_values[1] to marker -3-, etc.
                            # because the first column (marker -1-) is the state/condition value (state_or_cond)
                            active_markers = []
                            for idx, val in enumerate(branch_values, start=1):
                                if val != '-':
                                    # Actual marker number is idx + 1 (since branch_values starts at marker -2-)
                                    active_markers.append(idx + 1)

                            # Determine which line to report
                            line_no = -1
                            text_for_line = ""

                            if active_markers:
                                # Use the rightmost (highest) active marker
                                marker_idx = active_markers[-1]
                                line_no = branch_marker_to_line.get(marker_idx, section_end_line if section_end_line else -1)
                            else:
                                # No markers found, use section end line
                                line_no = section_end_line if section_end_line else -1

                            # Get the text for that line from the section
                            if line_no > 0:
                                for s in section:
                                    line_match_text = re.match(r"^\s*" + str(line_no) + r"\s+(.*\S)", s)
                                    if line_match_text:
                                        text_for_line = line_match_text.group(1).strip()
                                        break

                            combo_str = " ".join(branch_values) if branch_values else ""
                            desc = f"{state_or_cond} {combo_str}".strip()
                            gaps.append((line_no, text_for_line, desc))
                    i += 1
                continue
            else:
                i += 1
        else:
            i += 1

    return gaps


def report_results(module_lines: List[str], source_lines: Sequence[str]) -> None:
    line_section = extract_section(
        module_lines,
        "Line Coverage for Module",
        (
            "Cond Coverage for Module",
            "Toggle Coverage for Module",
            "FSM Coverage for Module",
            "Branch Coverage for Module",
            "Module Instance",
            "===============================================================================",
        ),
    )
    toggle_section = extract_section(
        module_lines,
        "Toggle Coverage for Module",
        (
            "FSM Coverage for Module",
            "Branch Coverage for Module",
            "Module Instance",
            "===============================================================================",
        ),
    )
    fsm_section = try_extract_section(
        module_lines,
        "FSM Coverage for Module",
        ("Branch Coverage for Module", "Module Instance", "==============================================================================="),
    )
    cond_section = try_extract_section(
        module_lines,
        "Cond Coverage for Module",
        (
            "Toggle Coverage for Module",
            "FSM Coverage for Module",
            "Branch Coverage for Module",
            "Module Instance",
            "===============================================================================",
        ),
    )
    branch_section = try_extract_section(
        module_lines,
        "Branch Coverage for Module",
        ("Module Instance", "==============================================================================="),
    )

    line_gaps = parse_line_gaps(line_section)
    toggle_gaps = parse_toggle_gaps(toggle_section)
    fsm_gaps = parse_fsm_gaps(fsm_section) if fsm_section else []
    cond_gaps = parse_cond_gaps(cond_section) if cond_section else []
    branch_gaps = parse_branch_gaps(branch_section) if branch_section else []

    def get_line_text(line_no: int) -> str:
        if 1 <= line_no <= len(source_lines):
            return source_lines[line_no - 1].strip()
        return "<source line unavailable>"

    print("\n=== Coverage Gaps ===")
    print("\nLine coverage:")
    if line_gaps:
        for line_no, covered, total, snippet in line_gaps:
            text = get_line_text(line_no)
            if text == "<source line unavailable>" and snippet:
                text = snippet
            print(f"  - Line {line_no}: {covered}/{total} hits -- {text}")
    else:
        print("  All executable lines were covered.")

    print("\nFSM transitions:")
    if fsm_section:
        if fsm_gaps:
            for transition, line_no in fsm_gaps:
                text = get_line_text(line_no)
                print(f"  - {transition}: {text} (line {line_no})")
        else:
            print("  All FSM transitions were covered.")
    else:
        print("  No FSM detected in design.")

    print("\nToggle coverage:")
    if toggle_gaps:
        for entry in toggle_gaps:
            print("  -", entry)
    else:
        print("  All monitored bits toggled in both directions.")

    print("\nCondition coverage:")
    if cond_section:
        if cond_gaps:
            for line_no, expr, combo in cond_gaps:
                print(f"  - Line {line_no}: {expr} (combo {combo})")
        else:
            print("  All condition combinations were covered.")
    else:
        print("  Condition coverage data not available in report.")

    print("\nBranch coverage:")
    if branch_section:
        if branch_gaps:
            for line_no, text, combo in branch_gaps:
                location = f"line {line_no}" if line_no >= 0 else "line ?"
                print(f"  - {location}: {text} (branch {combo})")
        else:
            print("  All branch outcomes were covered.")
    else:
        print("  Branch coverage data not available in report.")


def main(argv: Sequence[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dut", required=True, type=pathlib.Path, help="Path to DUT Verilog file")
    parser.add_argument(
        "--tb",
        required=True,
        type=pathlib.Path,
        help="Path to the testbench Verilog file",
    )
    parser.add_argument(
        "--module",
        type=str,
        help="Name of the DUT module to report (defaults to first module declaration in the DUT file)",
    )
    parser.add_argument(
        "--workdir",
        default=pathlib.Path.cwd(),
        type=pathlib.Path,
        help="Project directory that contains the Makefile (default: current directory)",
    )
    parser.add_argument(
        "--make",
        default="make",
        help="Make executable to invoke (default: make)",
    )
    parser.add_argument(
        "--skip-clean",
        action="store_true",
        help="Skip running 'make clean' before the flow",
    )
    parser.add_argument(
        "--cov-gui",
        action="store_true",
        help="Allow the cov target to spawn the GUI (default: off to keep CLI runs headless)",
    )
    args = parser.parse_args(argv)

    for path in [args.dut, args.tb]:
        if not path.exists():
            parser.error(f"Source file not found: {path}")

    module_name = args.module or guess_module_name(args.dut)
    source_lines = args.dut.read_text().splitlines()
    project_dir = args.workdir.resolve()
    if not project_dir.exists():
        parser.error(f"Project directory not found: {project_dir}")

    make_cmd = [args.make]
    print(f"Project directory: {project_dir}")

    # Clean up previous log files
    cleanup_logs(project_dir)

    if not args.skip_clean:
        run_make_target(make_cmd, "clean", project_dir)

    # Create file_list with the provided DUT and testbench files
    create_file_list(args.dut, args.tb, project_dir)

    run_make_target(make_cmd, "com", project_dir)
    run_make_target(make_cmd, "sim", project_dir)
    cov_args: Sequence[str] = ()
    if not args.cov_gui:
        cov_args = ("GUI=0",)
    run_make_target(make_cmd, "cov", project_dir, cov_args)

    cov_report_dir = project_dir / "cov_report"
    module_lines = get_module_block(cov_report_dir / "modinfo.txt", module_name)
    report_results(module_lines, source_lines)
    print(f"\nDetailed report kept under: {cov_report_dir}")

    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
