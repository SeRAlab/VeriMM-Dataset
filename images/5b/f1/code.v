module top_module(
  input [7:0] in1,
  input [7:0] in2,
  output [7:0] out_and,
  output [7:0] out_or,
  output [7:0] out_xor,
  output [7:0] out_not
);assign out_and = in1 & in2;
  assign out_or = in1 | in2;
  assign out_xor = in1 ^ in2;
  assign out_not = ~in1;

endmodule