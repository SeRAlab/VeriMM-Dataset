module top_module(In, Out);parameter Width = 32, 
  Chunk = 1, 
  Set = Width; 
  localparam Group = Chunk * Set; 
  input [Width-1:0] In; 
  output [Width-1:0] Out; 
  genvar i; 
  generate for(i = 0; i < Width; i = i + 1) begin:REVERSE 
  assign Out[i] = In[((Set - 1 - ((i % Group) / Chunk)) * Chunk) + ((i % Group) % Chunk) + ((i / Group) * Group)]; 
  end endgenerate 
 endmodule