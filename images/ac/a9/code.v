module top_module(
  input [mem_width-1:0] mem_addr,
  input [mem_width-1:0] mem_data,
  input [key_width-1:0] key,
  output [mem_width-1:0] enc_data
);parameter mem_width = 8; // width of memory data
parameter key_width = 8; // width of encryption or decryption key

// Encryption algorithm
// Here we use a simple XOR operation between the memory data and the key to encrypt or decrypt the data
assign enc_data = mem_data ^ key;

endmodule