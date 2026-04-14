module max_value (
  input a,
  input b,
  input c,
  output out
);

  assign out = (a > b) ? ((a > c) ? a : c) : ((b > c) ? b : c);

endmodule