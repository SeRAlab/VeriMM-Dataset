module top_module(A, B, Y);input A, B;
output Y;

wire not_A, not_B; 
wire and_AB, and_notA_notB;

// Invert A and B
not U1 (not_A, A); // Changed the instance name to U1
not U2 (not_B, B); // Changed the instance name to U2

// Compute A AND B and NOT A AND NOT B
and U3 (and_AB, A, B); // Changed the instance name to U3
and U4 (and_notA_notB, not_A, not_B); // Changed the instance name to U4

// Compute Y = (A AND B) OR (NOT A AND NOT B)
or U5 (Y, and_AB, and_notA_notB); // Changed the instance name to U5

endmodule