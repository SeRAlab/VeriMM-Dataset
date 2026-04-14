module top_module(A, B, Sub, Sum, Diff);input [3:0] A, B;
input Sub;
output [3:0] Sum, Diff;

wire [3:0] A_inv, B_inv, B_neg, Cin, D;
wire [4:0] S;

// Invert A and B
assign A_inv = ~A;
assign B_inv = ~B;

// Create 2's complement of B if Sub is 1
assign B_neg = B_inv + 1;

// Create carry input for subtraction
assign Cin = Sub;

// Perform addition or subtraction
assign S = {Cin, A} + {Sub, B_neg};

// Extract Sum and Diff from S
assign Sum = S[3:0];
assign Diff = S[3:0] + Sub;

// Create overflow flag
assign D = A_inv + B + Cin;

endmodule