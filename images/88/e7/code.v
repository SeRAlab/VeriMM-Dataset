module top_module(A, B, C, S);input [3:0] A, B;
input C;
output [3:0] S;

wire [3:0] B_neg;
assign B_neg = ~B + 1;

assign S = (C == 1) ? A + B_neg : A + B;

endmodule