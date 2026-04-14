module top_module(
  input [n-1:0] a,
  input [n-1:0] b,
  output greater,
  output less,
  output equal
);parameter n = 4; // number of bits in the input numbers

// Implement unsigned comparator here
assign greater = (a > b);
assign less = (a < b);
assign equal = (a == b);

// Implement signed comparator here
assign greater = ((a[n-1] == 1 && b[n-1] == 0) || (a[n-1] == b[n-1] && a > b));
assign less = ((a[n-1] == 0 && b[n-1] == 1) || (a[n-1] == b[n-1] && a < b));
assign equal = (a == b);

endmodule