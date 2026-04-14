module top_module(A, B, S, out);input [3:0] A, B;
input S;
output [3:0] out;

wire [3:0] B_comp;
assign B_comp = ~B + 1; // 2's complement of B

assign out = (S == 1) ? A + B_comp : A + B; // add or subtract based on S

endmodule