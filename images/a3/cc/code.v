module top_module(A, B, Ci, S, Co);input A, B, Ci;
output S, Co;

wire n1, n2, n3;

// Generate the sum bit and carry out using basic gates
assign n1 = A ^ B;      // XOR for A and B
assign S = n1 ^ Ci;     // XOR for sum including Carry-in
assign n2 = A & B;      // AND for Carry-out of A and B
assign n3 = n1 & Ci;    // AND for Carry-out of intermediate result and Carry-in
assign Co = n2 | n3;    // OR to determine final Carry-out

endmodule