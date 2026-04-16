# this script is to add a hierarchy to the dataset
import subprocess
import tempfile
import os
from datasets import load_dataset, Dataset
import time
import re


def check_hierarchy(verilog_code):
    with tempfile.NamedTemporaryFile(mode='w', suffix='.v', delete=False) as temp_file:
        temp_file.write(verilog_code)
        temp_file_name = temp_file.name
    
    try:
        # Build Yosys command
        # Use read_verilog to read file, -sv for SystemVerilog support, -Wall to show all warnings
        # If no errors after execution, return code is 0
        cmd = [
            'yosys',
            '-p', f'read_verilog -sv {temp_file_name}; hierarchy -auto-top'
        ]
        
        # Execute command
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=30  # 30s timeout
        )
        
        
        matches = re.findall(r'Used module:( +)', result.stdout)
        if len(matches)==0:
            return 1
        else:
            return len(list(set([len(s) for s in matches])))+1
        
    except Exception as e:
        print(f"Error running Yosys: {e}")
        return 0
    finally:
        # Ensure temp file is deleted
        if os.path.exists(temp_file_name):
            os.remove(temp_file_name)

start = time.time()
dataset = load_dataset("json", data_files="/path/to/dataset/data_concatenate_SYN_faiss.jsonl")
check_num=0


# hie_list = []
# for pair in dataset['train']:
#     pair['circuit_hierarchy']=0



new_pairs = []
for pair in dataset['train']:
    verilog_code = pair['code']
    check_num += 1
    if verilog_code.strip():  
        print("now is: "+str(check_num-1))
        pair['circuit_hierarchy']=check_hierarchy(verilog_code)
        print('hierarchy is: '+str(pair['circuit_hierarchy']))
    new_pairs.append(pair)
expanded_dataset = Dataset.from_list(new_pairs)

expanded_dataset.to_json("/path/to/dataset/data_concatenate_SYN_faiss_HIE.jsonl")
print("Time taken:", time.time() - start)