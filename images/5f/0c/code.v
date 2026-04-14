module top_module(A, B, C, D, Sel1, Sel0, Z);input [3:0] A, B, C, D;
input [1:0] Sel1, Sel0;
output [3:0] Z;

wire [3:0] w0, w1;

// Sel1 = 0, Sel0 = 0
assign w0 = A;
// Sel1 = 0, Sel0 = 1
assign w1 = B;
// Sel1 = 1, Sel0 = 0
assign w0 = C;
// Sel1 = 1, Sel0 = 1
assign w1 = D;

// Select the correct input
assign Z = (Sel1 == 0) ? w0 : w1;

endmodule