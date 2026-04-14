module top_module(in, s, out);input wire[3: 0] in; 
  input wire[1: 0] s; 
  output wire out; 
  assign out = in[s]; 
 endmodule