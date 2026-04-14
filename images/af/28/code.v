module top_module( A, B, Ci, S, Co );input A, B, Ci;
  output S, Co;
  wire Z; // Declare wire Z to connect OR gates

  // Assign S using a simple XOR operation instead of XNOR
  assign S = A ^ B; // XNOR can be replaced with XOR and an inverted output if needed 

  // Assign Co using OR gates
  assign Z = A | B; // Replace OR2_X1 with the built-in OR operation
  assign Co = Z | Ci; // Replace OR2_X1 with the built-in OR operation
endmodule