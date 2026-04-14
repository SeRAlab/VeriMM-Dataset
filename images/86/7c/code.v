module top_module(in, s, out);input wire[3: 0] in; 
  input wire[1: 0] s; 
  output wire out; 
  assign out = s == 2'b00 ? in[0] : s == 2'b01 ? in[1] : s == 2'b10 ? in[2] : s == 2'b11 ? in[3] : 1'b0; 
 endmodule