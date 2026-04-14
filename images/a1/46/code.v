module top_module(
  input A1,
  input A2,
  input B1,
  input B2,
  output X,
  input VPB,
  input VPWR,
  input VGND,
  input VNB
);wire sel;
  assign sel = A1 | A2;

  assign X = sel ? (A1 ? B1 : B2) : 1'b0;

endmodule