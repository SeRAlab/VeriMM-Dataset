module top_module(
  input [1:0] A,
  input [1:0] B,
  output EQ,
  output GT,
  input VPB,
  input VPWR,
  input VGND,
  input VNB
);wire[1:0] diff;
  assign diff = A - B;
  assign EQ = (diff[1] | diff[0]) ? 0 : 1;
  assign GT = diff[1] ? A[1] : (diff[0] ? A[0] : 0);

endmodule