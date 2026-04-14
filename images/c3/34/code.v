module karnaugh_map (
  input [3:0] x,
  output y
);
  wire w1, w2, w3, w4;
  assign w1 = x[0] & x[1];
  assign w2 = x[2] & x[3];
  assign w3 = x[1] & x[3];
  assign w4 = x[0] & x[2];
  assign y = w1 | w2 | w3 | w4;
endmodule
