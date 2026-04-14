#!/usr/bin/env python3
"""
Master script to process all chunk directories in 51k_5keys.
For each chunk, it:
1. Identifies circuits without schematic.svg or with bad waveform aspect ratio
2. Deletes them from JSONL and filesystem
"""

import os
import json
import shutil
import xml.etree.ElementTree as ET
from pathlib import Path


def check_svg_aspect_ratio(svg_path):
    """Check if SVG has width/height ratio > 10"""
    try:
        tree = ET.parse(svg_path)
        root = tree.getroot()

        # Get width and height attributes
        width = root.get('width', '')
        height = root.get('height', '')

        # Try to extract numeric values
        try:
            # Remove units like 'px', 'pt', etc.
            width_val = float(''.join(c for c in width if c.isdigit() or c == '.'))
            height_val = float(''.join(c for c in height if c.isdigit() or c == '.'))

            if height_val == 0:
                return True, width_val / 1

            aspect_ratio = width_val / height_val
            return aspect_ratio > 10, aspect_ratio
        except (ValueError, TypeError):
            # If we can't parse dimensions, check viewBox
            viewBox = root.get('viewBox', '')
            if viewBox:
                parts = viewBox.split()
                if len(parts) == 4:
                    vb_width = float(parts[2])
                    vb_height = float(parts[3])
                    if vb_height == 0:
                        return True, vb_width / 1
                    aspect_ratio = vb_width / vb_height
                    return aspect_ratio > 10, aspect_ratio
            return False, 0
    except Exception:
        return False, 0


def process_chunk(chunk_path):
    """Process a single chunk directory"""
    chunk_name = chunk_path.name
    jsonl_file = chunk_path / f"chunk_{chunk_name}_processed.jsonl"

    if not jsonl_file.exists():
        print(f"  ⚠ No JSONL file found, skipping")
        return None

    # Get all circuit folders (2-char hex names)
    folders = [f for f in chunk_path.iterdir() if f.is_dir() and len(f.name) == 2]

    bad_circuits = []

    # Check each folder
    for folder in folders:
        circuit_id = f"{chunk_name}{folder.name}"
        schematic_svg = folder / "schematic.svg"
        waveform_svg = folder / "waveform.svg"

        # Check for missing schematic.svg
        if not schematic_svg.exists():
            bad_circuits.append(circuit_id)
            continue

        # Check waveform aspect ratio
        if waveform_svg.exists():
            is_bad, ratio = check_svg_aspect_ratio(waveform_svg)
            if is_bad:
                bad_circuits.append(circuit_id)

    if not bad_circuits:
        print(f"  ✓ No bad circuits found")
        return {"chunk": chunk_name, "deleted": 0, "remaining": len(folders)}

    # Read and filter JSONL
    output_lines = []
    deleted_count = 0
    bad_circuits_set = set(bad_circuits)

    with open(jsonl_file, 'r') as f:
        for line in f:
            data = json.loads(line)
            circuit_id = data.get('id', '')
            if circuit_id in bad_circuits_set:
                deleted_count += 1
            else:
                output_lines.append(line)

    # Write filtered JSONL
    with open(jsonl_file, 'w') as f:
        f.writelines(output_lines)

    # Delete folders
    deleted_folders = 0
    for circuit_id in bad_circuits:
        folder_name = circuit_id[-2:]  # Last 2 characters
        folder_path = chunk_path / folder_name
        if folder_path.exists() and folder_path.is_dir():
            shutil.rmtree(folder_path)
            deleted_folders += 1

    result = {
        "chunk": chunk_name,
        "deleted": deleted_count,
        "remaining": len(output_lines)
    }

    print(f"  ✓ Deleted {deleted_count} circuits, {len(output_lines)} remaining")
    return result


def main():
    base_path = Path('/data/syyun/dataset/pic_gen_for_57k/51k_5keys')

    # Get all chunk directories
    chunk_dirs = sorted([d for d in base_path.iterdir() if d.is_dir() and len(d.name) == 2])

    print("="*70)
    print(f"Processing {len(chunk_dirs)} chunk directories in 51k_5keys")
    print("="*70)
    print()

    results = []

    for i, chunk_dir in enumerate(chunk_dirs, 1):
        print(f"[{i}/{len(chunk_dirs)}] Processing chunk {chunk_dir.name}...")
        result = process_chunk(chunk_dir)
        if result:
            results.append(result)
        print()

    # Summary
    print("="*70)
    print("SUMMARY")
    print("="*70)

    total_deleted = sum(r['deleted'] for r in results)
    total_remaining = sum(r['remaining'] for r in results)

    print(f"Chunks processed:     {len(results)}")
    print(f"Total circuits deleted: {total_deleted}")
    print(f"Total circuits remaining: {total_remaining}")
    print()

    # Show chunks with deletions
    chunks_with_deletions = [r for r in results if r['deleted'] > 0]
    if chunks_with_deletions:
        print(f"Chunks with deletions ({len(chunks_with_deletions)}):")
        for r in chunks_with_deletions:
            print(f"  - Chunk {r['chunk']}: {r['deleted']} deleted")

    print("="*70)
    print("✓ All chunks processed successfully!")
    print("="*70)


if __name__ == '__main__':
    main()
