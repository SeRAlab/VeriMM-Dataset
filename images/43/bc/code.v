module top_module(C, A, B);output [3:0] C;
  input [3:0] A;
  input [3:0] B;
  
  wire c0, c1, c2;
  
  // First bit addition
  xor(C[0], A[0], B[0]);
  and(c0, A[0], B[0]);
  
  // Second bit addition
  xor(C[1], A[1], B[1]);
  xor(c1, A[1], B[1]);
  and(c1, c1, c0);
  
  // Third bit addition
  xor(C[2], A[2], B[2]);
  xor(c2, A[2], B[2]);
  and(c2, c2, c1);
  
  // Fourth bit addition
  xor(C[3], A[3], B[3]);
  and(C[3], C[3], c2);
  
endmodule