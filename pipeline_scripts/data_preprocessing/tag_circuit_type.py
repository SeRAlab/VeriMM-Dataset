# this script is used to add one columns to the dataset, namely circuit type(combinational or sequential).
from datasets import load_dataset, Dataset
import time

count_hierarchy = 0
count_sequential = 0
start = time.time()
dataset = load_dataset("json", data_files="/path/to/dataset/dedupli_faiss_3dataset.jsonl")
expanded_pairs = []
for pair in dataset['train']:
    if pair['code'].count("posedge")>0 or pair['code'].count("negedge")>0:
        pair['type'] = 'sequential'
        count_sequential += 1
    else:
        pair['type'] = 'combinational' 

    expanded_pairs.append(pair)
expanded_dataset = Dataset.from_list(expanded_pairs)

expanded_dataset.to_json("/path/to/dataset/RTLLM_type.jsonl")
print("hierarchy count:", count_hierarchy)
print("sequential count:", count_sequential)
print("Time taken:", time.time() - start)
print(1)