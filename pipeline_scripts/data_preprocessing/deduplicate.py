from sentence_transformers import SentenceTransformer
from datasets import load_dataset, Dataset
import faiss
import numpy as np
import time

start = time.time()
dataset = load_dataset("json", data_files="/path/to/dataset/data_concatenate_SYN.jsonl")
# dataset = load_dataset("json", data_files="/path/to/dataset/dedupli_faiss_3dataset.jsonl")
# print(type(dataset))

# print(dataset['train'][0])


texts=[]
for items in dataset['train']:
    texts.append(items['code'])

# Assume you have hundreds of thousands of sentences
# texts = [...]  # list of strings, length N

# 1. Encode into sentence embeddings
# model = SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')
model = SentenceTransformer('sentence-transformers/paraphrase-MiniLM-L3-v2', device='cuda') 
# model = SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2', device='cuda')
embeddings = model.encode(texts, batch_size=512, show_progress_bar=True, normalize_embeddings=True)
embeddings = np.array(embeddings).astype('float32')

# 2. Build FAISS Index
dimension = embeddings.shape[1]
index = faiss.IndexFlatIP(dimension)  # Inner Product equivalent to Cosine (after normalization)
index.add(embeddings)

# 3. Query nearest neighbors for each vector (k=5, adjustable)
k = 5
D, I = index.search(embeddings, k)  # D is similarity score, I is index


# res = faiss.StandardGpuResources()
# index_flat = faiss.IndexFlatIP(dimension)
# gpu_index = faiss.index_cpu_to_gpu(res, 4, index_flat)
# gpu_index.add(embeddings)
# D, I = gpu_index.search(embeddings, k)

# 4. Semantic deduplication logic
threshold = 0.95
n = len(texts)
duplicate_flags = [False] * n

for i in range(n):
    if duplicate_flags[i]:
        continue
    for j in range(1, k):  # skip self (j=0)
        neighbor = I[i][j]
        sim = D[i][j]
        if sim >= threshold:
            duplicate_flags[neighbor] = True  # mark as duplicate
            # print(str(i)+' '+str(neighbor))
# 5. Keep unique texts
unique_texts = [texts[i] for i in range(n) if not duplicate_flags[i]]
unique_pairs=[dataset['train'][i] for i in range(n) if not duplicate_flags[i]]
print("Count after dedup:", len(unique_texts))

unique_dataset = Dataset.from_list(unique_pairs)

# # Optional: save deduplicated data
unique_dataset.to_json("/path/to/dataset/data_concatenate_SYN_faiss.jsonl")
end = time.time()
print(f"Time elapsed: {end - start:.4f} seconds")