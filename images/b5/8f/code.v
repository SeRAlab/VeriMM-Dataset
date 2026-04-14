module top_module(
  input signed [31:0] x,
  output signed [31:0] wrap
);wire signed [31:0] Two_Pi; // sfix32_En27
  assign Two_Pi = 32'sb00110010010000111111011010101001;

  wire signed [31:0] Two_Pi_Minus; // sfix32_En27
  assign Two_Pi_Minus = -Two_Pi;

  wire signed [31:0] x_plus_2pi; // sfix32_En27
  assign x_plus_2pi = x + Two_Pi;

  wire signed [31:0] x_minus_2pi; // sfix32_En27
  assign x_minus_2pi = x + Two_Pi_Minus;

  wire [31:0] greater_than_or_equal_to_2pi; // sfix32_En27
  assign greater_than_or_equal_to_2pi = (x >= Two_Pi) ? x_minus_2pi : x;

  wire [31:0] less_than_0; // sfix32_En27
  assign less_than_0 = (x < 0) ? x_plus_2pi : greater_than_or_equal_to_2pi;

  assign wrap = less_than_0;

endmodule