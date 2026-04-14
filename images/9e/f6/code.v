module top_module(inp, res);parameter signed [31:0] orig_width = 4; 
  parameter signed [31:0] new_width = 2; 
  input [orig_width - 1 : 0] inp; 
  output [new_width - 1 : 0] res; 
  parameter signed [31:0] pad_pos = new_width - orig_width -1; 
  wire [new_width-1:0] result; 
  genvar i; 
  assign res = result; 
  generate 
  if (new_width >= orig_width) 
  begin:u0 
  assign result[new_width-1:new_width-orig_width] = inp[orig_width-1:0]; 
  end 
  endgenerate 
  generate 
  if (pad_pos >= 0) 
  begin:u1 
  assign result[pad_pos:0] = {(pad_pos+1){1'b0}}; 
  end 
  endgenerate 
 endmodule