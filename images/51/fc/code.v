module top_module(A, B, Z);input [1:0] A;
  input [1:0] B;
  output Z;
  wire eq, gt;

  assign eq = (A == B);
  assign gt = (A > B);

  assign Z = (gt | eq);

endmodule