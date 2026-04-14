module top_module(x, y, z, o);input [31:0] x, y, z; 
  output [31:0] o; 
  assign o = z ^ (x & (y ^ z)); 
 endmodule