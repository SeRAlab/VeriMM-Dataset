#!/usr/bin/env python3
"""
Testcase Insertion Script
Inserts testcases from a testcase file into a testbench template file

change for version2: remove check_outpus task from LLM results
"""

import re
import sys
import os
from pathlib import Path


def extract_tasks(testcase_file):
    """
    Extract all task definitions from the testcase file.
    Returns: dict with task_name -> task_content
    """
    with open(testcase_file, 'r', encoding='utf-8') as f:
        content = f.read()

    tasks = {}

    # Pattern to match task definitions
    # Matches: task task_name; ... endtask
    pattern = r'task\s+(\w+)\s*;(.*?)endtask'

    matches = re.finditer(pattern, content, re.DOTALL)

    for match in matches:
        task_name = match.group(1)
        task_body = match.group(2)

        # Clean up the task body - preserve original formatting
        # Store the complete task including task/endtask keywords
        # Match the indentation style used in the template
        task_content = f"    task {task_name};\n{task_body}    endtask"
        tasks[task_name] = task_content

    return tasks


def get_testcase_task_names(tasks):
    """
    Get list of testcase task names (those starting with 'testcase')
    Returns: list of task names in order
    """
    testcase_tasks = []
    for task_name in tasks.keys():
        if task_name.startswith('testcase'):
            testcase_tasks.append(task_name)

    # Sort to maintain consistent order
    testcase_tasks.sort()
    return testcase_tasks


def get_helper_task_names(tasks):
    """
    Get list of helper task names (those not starting with 'testcase' and not 'reset_dut' or 'check_outputs')
    Returns: list of task names
    """
    helper_tasks = []
    for task_name in tasks.keys():
        if not task_name.startswith('testcase') and task_name not in ['reset_dut', 'check_outputs']:
            helper_tasks.append(task_name)

    return helper_tasks


def insert_testcases_into_template(template_file, tasks, output_file):
    """
    Insert testcases into the template file and generate the output testbench.
    """
    with open(template_file, 'r', encoding='utf-8') as f:
        template_content = f.read()

    # Step 1: Replace placeholder tasks with actual implementations
    # For example, replace the reset_dut placeholder with the actual reset_dut task

    # Find and replace each task that exists in both template and testcases
    for task_name, task_content in tasks.items():
        if task_name in ['reset_dut']:  # Add other common task names if needed
            # Pattern to match the placeholder task in template
            # Matches: task task_name; ... endtask
            placeholder_pattern = rf'task\s+{task_name}\s*;.*?endtask'

            if re.search(placeholder_pattern, template_content, re.DOTALL):
                # Use a function for replacement to avoid escape sequence interpretation
                template_content = re.sub(
                    placeholder_pattern,
                    lambda m: task_content,
                    template_content,
                    flags=re.DOTALL
                )

    # Step 2: Remove placeholder testcase tasks (testcases1, testcases2, etc.)
    # Pattern to match testcasesN tasks
    placeholder_testcase_pattern = r'task\s+testcases\d+\s*;.*?endtask\s*\n'
    template_content = re.sub(
        placeholder_testcase_pattern,
        '',
        template_content,
        flags=re.DOTALL
    )

    # Also remove the comment about defining other testcases
    template_content = re.sub(
        r'\s*//define other testcases here\s*\n',
        '',
        template_content
    )

    # Step 3: Insert helper tasks and testcase tasks
    # Find the location to insert (after reset_dut task, before "// Test stimulus")
    helper_tasks = get_helper_task_names(tasks)
    testcase_tasks = get_testcase_task_names(tasks)

    # Build the insertion string - helper tasks first, then testcase tasks
    task_insertion = ""

    # Add helper tasks first
    for task_name in helper_tasks:
        task_insertion += f"{tasks[task_name]}\n\n"

    # Then add testcase tasks
    for task_name in testcase_tasks:
        task_insertion += f"{tasks[task_name]}\n\n"

    # Find the insertion point - after reset_dut endtask
    # Look for the pattern: endtask followed by empty lines and then "// Test stimulus"
    insertion_pattern = r'(endtask\s*\n)(\s*\n)(\s*// Test stimulus)'

    if re.search(insertion_pattern, template_content):
        template_content = re.sub(
            insertion_pattern,
            lambda m: f'{m.group(1)}\n{task_insertion}{m.group(3)}',
            template_content,
            count=1
        )
    else:
        # Fallback: insert before "// Test stimulus"
        template_content = re.sub(
            r'(\s*// Test stimulus)',
            lambda m: f'\n{task_insertion}{m.group(1)}',
            template_content,
            count=1
        )

    # Step 4: Update the initial block to call all testcases
    # Replace testcases1(), testcases2(), and the comment

    # Build the testcase calls string
    testcase_calls = ""
    for task_name in testcase_tasks:
        testcase_calls += f"        {task_name}();\n"
    testcase_calls += "        \n        "  # Add spacing

    # Pattern to match the placeholder calls and comment
    # Match from "testcases1();" to the end of "// Call other test case tasks here" and following whitespace
    call_pattern = r'        testcases1\(\);\s+testcases2\(\);\s+// Call other test case tasks here\s+\n\s+'

    if re.search(call_pattern, template_content):
        template_content = re.sub(
            call_pattern,
            f'{testcase_calls}\n',
            template_content,
            count=1
        )
    else:
        # Try alternate pattern
        call_pattern2 = r'testcases1\(\);\s*testcases2\(\);\s*// Call other test case tasks here\s*'
        if re.search(call_pattern2, template_content):
            template_content = re.sub(
                call_pattern2,
                testcase_calls.strip(),
                template_content,
                count=1
            )

    # Write the result
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(template_content)

    print(f"Testbench generated successfully: {output_file}")
    print(f"  - Inserted {len(testcase_tasks)} testcase(s): {', '.join(testcase_tasks)}")
    if 'reset_dut' in tasks:
        print(f"  - Replaced reset_dut task")


def main():
    """Main function to handle command-line usage."""
    if len(sys.argv) < 4:
        print("Usage: python insert_testcases.py <testcase_file> <template_file> <output_file>")
        print("\nExample:")
        print('  python insert_testcases.py testcases.v template_tb.v output_tb.v')
        sys.exit(1)

    testcase_file = sys.argv[1]
    template_file = sys.argv[2]
    output_file = sys.argv[3]

    # Check if files exist
    if not os.path.exists(testcase_file):
        print(f"Error: Testcase file '{testcase_file}' not found")
        sys.exit(1)

    if not os.path.exists(template_file):
        print(f"Error: Template file '{template_file}' not found")
        sys.exit(1)

    try:
        print(f"Extracting testcases from: {testcase_file}")
        tasks = extract_tasks(testcase_file)
        print(f"Found {len(tasks)} task(s)")

        print(f"\nProcessing template: {template_file}")
        insert_testcases_into_template(template_file, tasks, output_file)

    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
