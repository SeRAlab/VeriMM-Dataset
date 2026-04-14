module top_module(
  input [3:0] num1,
  input [3:0] num2,
  input carry_in,
  output [3:0] sum,
  output carry_out
);assign {carry_out, sum} = num1 + num2 + carry_in;

endmodule