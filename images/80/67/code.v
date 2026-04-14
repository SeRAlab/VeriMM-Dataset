module top_module(
  input [31:0] input_value,
  input [4:0] shift_amount,
  output [31:0] output_value
);assign output_value = input_value >> shift_amount;

endmodule