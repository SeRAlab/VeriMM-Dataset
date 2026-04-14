module top_module(in,out);input [4:0] in; 
  output [31:0] out; 
  assign out = in[4]? {27'b0, in}: {27'b1, in}; 
 endmodule