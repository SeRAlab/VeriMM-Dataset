module top_module(
  input x1,
  input x2,
  input x3,
  input x4,
  output y
);wire w1, w2, w3, w4, w5, w6, w7, w8;

  assign w1 = x1 & x4;
  assign w2 = x1 & x2 & x3;
  assign w3 = x1 & x2 & x4;
  assign w4 = x1 & x3 & x4;
  assign w5 = x2 & x3 & x4;
  assign w6 = x2 & x4;
  assign w7 = x3 & x4;
  assign w8 = x1 & x2 & x3 & x4;

  assign y = w1 | w2 | w3 | w4 | w5 | w6 | w7 | w8;

endmodule