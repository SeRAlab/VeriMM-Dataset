module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire n1, n2, n3, n4;

  // XOR gates using native Verilog operators
  assign n1 = A ^ B;    // n1 = A XOR B
  assign S = n1 ^ Ci;   // S = n1 XOR Ci

  // AND gates using native Verilog operators
  assign n2 = A & B;    // n2 = A AND B
  assign n3 = n1 & Ci;  // n3 = n1 AND Ci
  assign Co = n2 | n3;  // Co = n2 OR n3
endmodule