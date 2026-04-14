module top_module(
  input signed [n+m-1:0] num1,
  input signed [n+m-1:0] num2,
  output signed [n+m-1:0] result
);parameter n = 4; // number of integer bits
parameter m = 2; // number of fractional bits

// Arithmetic operations
// Addition
assign result = num1 + num2;
// Subtraction
assign result = num1 - num2;
// Multiplication
assign result = num1 * num2;
// Division
assign result = num1 / num2;

endmodule