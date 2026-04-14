module top_module(
  A,
  B,
  C,
  D,
  Y
);input A, B, C, D;
  output Y;

  wire w1, w2;

  // Instantiate 3-input AND gate
  wire and3_out;
  assign w1 = A & B & C; // Simple implementation of 3-input AND logic

  // Instantiate 2-input AND gate
  assign w2 = w1 & D; // Simple implementation of 2-input AND logic

  assign Y = w2;

endmodule