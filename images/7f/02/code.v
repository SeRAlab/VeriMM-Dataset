module top_module(input [15:0] in, output [15:0] out);assign out[15:2] = in[13:0];
  assign out[1] = 0;
  assign out[0] = 0;
endmodule