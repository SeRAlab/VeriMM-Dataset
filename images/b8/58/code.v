module top_module(
  input a,
  input b,
  input c,
  input d,
  output out
);wire ab, cd, not_cd;

  // AND gate for a and b
  assign ab = a & b;

  // OR gate for c and d
  assign cd = c | d;

  // NOT gate for cd
  assign not_cd = ~cd;

  // AND gate for ab and not_cd
  assign out = ab & not_cd;

endmodule