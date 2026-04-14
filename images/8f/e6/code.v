module top_module(A, B, CI, SUM);input [7:0] A;
input [7:0] B;
input CI;
output [7:0] SUM;

assign SUM = A + B + CI;endmodule