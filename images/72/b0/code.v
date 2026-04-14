module top_module(encode_in,data_out);parameter WIDTH = 64; 
 parameter N = log2(WIDTH); 
 input [N-1:0] encode_in; 
 output [WIDTH-1:0] data_out; 
 reg [WIDTH-1:0] data_out; 
 integer i; 
 always @(*) 
 begin 
  data_out = 0; 
  data_out = data_out + 2**(encode_in); 
 end 
 function integer log2; 
 input [32:0] depth; 
 integer j; 
 begin 
  log2 = 1; 
  for (j=0; 2**j < depth; j=j+1) 
  log2 = j + 1; 
 end 
 endfunction 
 endmodule