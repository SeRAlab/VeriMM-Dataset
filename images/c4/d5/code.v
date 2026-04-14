module four_bit_adder(
  input [3:0] A,
  input [3:0] B,
  output [3:0] S,
  output Cout
);

  wire [3:0] C;

  assign S = A + B;
  assign C = {A[3], B[3], S[3]};

  assign Cout = (C[2] & ~C[1]) | (~C[2] & C[0]);

endmodule