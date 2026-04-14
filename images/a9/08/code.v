module top_module(in, out);parameter IN_WIDTH=8; 
  parameter OUT_WIDTH=(1 << IN_WIDTH); 
  input [IN_WIDTH-1:0] in; 
  output [OUT_WIDTH-1:0] out; 
  genvar i; 
  generate 
  for (i = 0; i < OUT_WIDTH; i = i + 1) 
  begin: SELECT 
  assign out[i] = (i == in) ? 1'b1 : 1'b0; 
  end 
  endgenerate 
 endmodule