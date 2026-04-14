module top_module(A, B, S, Y);input [3:0] A, B;
  input S;
  output [3:0] Y;

  wire C1, C2;
  wire [3:0] SUM;

  // Implementing the full-adder subcircuit
  // with basic gates
  xor x1(SUM[0], A[0], B[0]);
  xor x2(SUM[1], A[1], B[1]);
  xor x3(SUM[2], A[2], B[2]);
  xor x4(SUM[3], A[3], B[3]);

  and a1(C1, A[0], B[0]);
  and a2(C2, A[1], B[1]);

  xor x5(SUM[1], SUM[1], C1);
  xor x6(SUM[2], SUM[2], C2);

  and a3(C1, SUM[0], S);
  and a4(C2, SUM[1], S);

  xor x7(Y[0], SUM[0], S);
  xor x8(Y[1], SUM[1], C1);
  xor x9(Y[2], SUM[2], C2);
  xor x10(Y[3], SUM[3], C1);

endmodule