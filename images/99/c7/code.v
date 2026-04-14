module top_module(
  input a,
  input b,
  output out_sum,
  output out_carry
);assign out_sum = a ^ b;
assign out_carry = a & b;endmodule