module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;

  wire w1, w2, w3;

  // Replace unknown module types with built-in Verilog operators
  assign w1 = A ^ B;       // XOR
  assign S = w1 ^ Ci;      // XOR
  assign w2 = A & B;       // AND
  assign w3 = w1 & Ci;     // AND
  assign Co = w2 | w3;     // OR
endmodule