module full_adder
(
  input a, 
  input b, 
  input carry_in, 

  output sum, 
  output carry_out
);

  assign {carry_out, sum} = a + b + carry_in;

endmodule

module ripple_carry_adder
(
  input [3:0] a,
  input [3:0] b,
  input carry_in,

  output [3:0] sum,
  output carry_out
);

  wire c1, c2, c3;

  full_adder fa0 (.a(a[0]), .b(b[0]), .carry_in(carry_in), .sum(sum[0]), .carry_out(c1));
  full_adder fa1 (.a(a[1]), .b(b[1]), .carry_in(c1), .sum(sum[1]), .carry_out(c2));
  full_adder fa2 (.a(a[2]), .b(b[2]), .carry_in(c2), .sum(sum[2]), .carry_out(c3));
  full_adder fa3 (.a(a[3]), .b(b[3]), .carry_in(c3), .sum(sum[3]), .carry_out(carry_out));

endmodule