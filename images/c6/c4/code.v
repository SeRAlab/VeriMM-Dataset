module compare_module(
  input [1:0] A,
  input B,
  output Z
);

  assign Z = (A >= B) ? 1 : 0;

endmodule