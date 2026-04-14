module top_module(
  input [3:0] a,
  input [3:0] b,
  input cin,
  output [3:0] sum,
  output cout
);wire [3:0] temp_sum;
  wire [4:0] temp_carry;

  assign temp_sum = a + b + cin;
  assign temp_carry = {cin, temp_sum} + 1'b0;

  assign sum = temp_sum;
  assign cout = temp_carry[4];

endmodule