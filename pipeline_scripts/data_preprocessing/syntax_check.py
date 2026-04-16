# check verilog code syntax, if has syntax error, remove it from the dataset
#use iverilog or yosys to check syntax
import subprocess
import tempfile
import os
from datasets import load_dataset, Dataset
import time

def check_verilog_syntax_ivl(verilog_code: str):
    if not verilog_code.strip():
        return False
        
    with tempfile.NamedTemporaryFile(suffix=".v", delete=False, mode="w") as tmp_file:
        tmp_file.write(verilog_code)
        tmp_file_path = tmp_file.name

    try:
        result = subprocess.run(
            ["iverilog", "-t", "null", "-o", "/path/to/null", tmp_file_path],
            capture_output=True,
            text=True,
            timeout=10  # 10s timeout
        )
        return result.returncode == 0
        
    except subprocess.TimeoutExpired:
        print(f"Timeout while checking Verilog syntax")  # print timeout info
        return False  # return False, indicating syntax check failed
    finally:
        try:
            os.remove(tmp_file_path)  # ensure temp file is deleted
        except:
            pass

def check_verilog_syntax_yos(verilog_code):
    with tempfile.NamedTemporaryFile(mode='w', suffix='.v', delete=False) as temp_file:
        temp_file.write(verilog_code)
        temp_file_name = temp_file.name
    
    try:
        # Build Yosys command
        # Use read_verilog to read file, -sv for SystemVerilog support, -Wall to show all warnings
        # If no errors after execution, return code is 0
        cmd = [
            'yosys',
            '-q',                # quiet mode, reduce output
            '-p', f'read_verilog -sv {temp_file_name}'
        ]
        
        # Execute command
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=10  # 10s timeout
        )
        
        # If return code is 0, syntax check passed
        return result.returncode == 0
        
    except Exception as e:
        print(f"Error running Yosys: {e}")
        return False
    finally:
        # Ensure temp file is deleted
        if os.path.exists(temp_file_name):
            os.remove(temp_file_name)


start = time.time()
dataset = load_dataset("json", data_files="/path/to/dataset/dedupli_faiss_3dataset_EXP_RM.jsonl")
correct_pairs = []
check_num=0
correct_num=0
for pair in dataset['train']:
    verilog_code = pair['code']
    check_num += 1
    if verilog_code.strip():  # ensure code is not empty
        print("now is: "+str(check_num-1))
        if check_verilog_syntax_yos(verilog_code):
            correct_pairs.append(pair)
            correct_num += 1
        else:
            # print(verilog_code)
            print("wrong index:"+str(check_num-1))
            print(f"Checked {check_num} pairs, correct pairs: {correct_num}")
expanded_dataset = Dataset.from_list(correct_pairs)

expanded_dataset.to_json("/path/to/dataset/dedupli_faiss_3dataset_EXP_SYN.jsonl")
print("Time taken:", time.time() - start)

