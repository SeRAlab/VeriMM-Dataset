module top_module(
  input signed [15:0] a, b, c,
  output signed [15:0] y
);wire u1_lt;
  assign u1_lt = (a < b);

  wire signed [15:0] max_ab;
  assign max_ab = u1_lt ? b : a;

  wire u2_lt;
  assign u2_lt = (c > max_ab);

  assign y = u2_lt ? c : max_ab;

endmodule