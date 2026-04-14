module top_module(
  input [2:0] A,
  input [2:0] B,
  output y
);wire a2_b2 = (A[2] > B[2]);
  wire a2_eq_b2 = (A[2] == B[2]);
  wire a1_b1 = (A[1] > B[1]);
  wire a1_eq_b1 = (A[1] == B[1]);
  wire a0_b0 = (A[0] > B[0]);
  
  assign y = (a2_b2 || (a2_eq_b2 && (a1_b1 || (a1_eq_b1 && a0_b0)))) ? 1'b1 : 1'b0;
  
endmodule