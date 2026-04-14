module top_module(
  output Y,
  input A,
  input B,
  input C,
  input D,
  input VPWR,
  input VGND,
  input VPB,
  input VNB
);wire w1, w2, w3, w4, w5, w6, w7;

  assign w1 = ~(A & B);
  assign w2 = ~(C & D);
  assign w3 = ~(w1 & w2);
  assign w4 = ~(w3 & VPB);
  assign w5 = ~(w3 & VNB);
  assign w6 = ~(w4 & VGND);
  assign w7 = ~(w5 & VPWR);
  assign Y = ~(w6 & w7);

endmodule