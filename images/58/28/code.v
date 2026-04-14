module top_module(data_in,multi_bit);parameter WIDTH = 64; 
 parameter N = log2(WIDTH); 
 input [WIDTH-1:0] data_in; 
 output multi_bit; 
 reg [N-1:0] sum; 
 reg multi_bit; 
 integer j; 
 always @(*) 
 begin 
  multi_bit = 0; 
  sum = 0; 
  for (j=WIDTH-1; j >= 0; j = j-1) 
  sum = sum + data_in[j]; 
  if (sum > 1) 
  multi_bit = 1; 
 end 
 function integer log2; 
 input [32:0] depth; 
 integer i; 
 begin 
  log2 = 1; 
  for (i=0; 2**i < depth; i=i+1) 
  log2 = i + 1; 
 end 
 endfunction 
 endmodule