module top_module(
  input [15:0] A,
  input [15:0] B,
  input C,
  output [15:0] Y
);assign Y = C ? ~(A & B) : (A & B);

endmodule