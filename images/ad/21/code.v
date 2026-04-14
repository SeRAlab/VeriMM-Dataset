module top_module(
  input [1:0] in,
  input enable,
  output [3:0] out
);assign out[0] = ~(in[1] | in[0] | enable);
  assign out[1] = ~(in[1] | ~in[0] | enable);
  assign out[2] = ~(~in[1] | in[0] | enable);
  assign out[3] = ~(~in[1] | ~in[0] | enable);
  
endmodule