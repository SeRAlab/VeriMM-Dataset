module top_module(
  input [3:0] A,
  input [3:0] B,
  input mode,
  output [3:0] sum,
  output carry_borrow
);wire [4:0] temp_sum;
  wire temp_carry_borrow;
  
  assign temp_sum = mode ? A - B : A + B;
  assign carry_borrow = (temp_sum > 4'b1111) ? 1'b1 : 1'b0;
  assign sum = temp_sum[3:0];
  
endmodule