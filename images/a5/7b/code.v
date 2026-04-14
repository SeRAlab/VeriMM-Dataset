module top_module(
  input [31:0] input_num,
  input [4:0] shift_amount,
  output [31:0] left_shifted,
  output [31:0] right_shifted,
  output [31:0] arithmetic_shifted
);assign left_shifted = input_num << shift_amount;
  assign right_shifted = input_num >> shift_amount;
  assign arithmetic_shifted = (input_num[31] == 1) ? { {1'b1}, input_num[31:1] } : input_num >> shift_amount;

endmodule