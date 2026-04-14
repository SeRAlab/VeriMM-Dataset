module top_module( in, out );input [63:0] in; 
  output [63:0] out; 
  assign out = in + 64'h01; 
 endmodule