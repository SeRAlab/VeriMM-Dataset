module top_module( A, Q );input [1:0] A;
  output [1:0] Q;
  assign Q = { (A[1] ^ A[0]), A[1] };endmodule