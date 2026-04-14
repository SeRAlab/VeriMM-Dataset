module xor_4bit(
  input [3:0] A,
  input [3:0] B,
  output [3:0] Y
);

  wire w1, w2, w3, w4, w5, w6, w7;

  xor x1(w1, A[0], B[0]);
  xor x2(w2, A[1], B[1]);
  xor x3(w3, A[2], B[2]);
  xor x4(w4, A[3], B[3]);

  and a1(w5, w1, w2);
  and a2(w6, w3, w4);
  and a3(w7, w5, w6);

  xor x5(Y[0], A[0], B[0]);
  xor x6(Y[1], A[1], B[1]);
  xor x7(Y[2], A[2], B[2]);
  xor x8(Y[3], A[3], B[3]);

endmodule