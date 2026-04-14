module top_module(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] S,
  output Cout
);wire [3:0] C;
  wire [3:0] D;

  assign C[0] = A[0] ^ B[0] ^ Cin;
  assign D[0] = A[0] & B[0] | A[0] & Cin | B[0] & Cin;

  assign C[1] = A[1] ^ B[1] ^ D[0];
  assign D[1] = A[1] & B[1] | A[1] & D[0] | B[1] & D[0];

  assign C[2] = A[2] ^ B[2] ^ D[1];
  assign D[2] = A[2] & B[2] | A[2] & D[1] | B[2] & D[1];

  assign C[3] = A[3] ^ B[3] ^ D[2];
  assign D[3] = A[3] & B[3] | A[3] & D[2] | B[3] & D[2];

  assign S = C;
  assign Cout = D[3];
endmodule