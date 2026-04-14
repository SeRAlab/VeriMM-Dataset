module top_module(A, B, Y);parameter A_SIGNED = 0;
  parameter B_SIGNED = 0;
  parameter A_WIDTH = 1;
  parameter B_WIDTH = 1;
  parameter Y_WIDTH = 1;

  input [A_WIDTH-1:0] A;
  input [B_WIDTH-1:0] B;
  output [Y_WIDTH-1:0] Y;

  wire [A_WIDTH-1:0] shifted_A;
  assign shifted_A = (B >= 0) ? (A << B) : (A >> -B);

  assign Y = shifted_A;

endmodule