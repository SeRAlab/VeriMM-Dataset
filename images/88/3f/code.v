module top_module(A, B, Y);parameter A_WIDTH = 0;
parameter B_WIDTH = 0;

input [A_WIDTH-1:0] A;
input [B_WIDTH-1:0] B;
output [A_WIDTH+B_WIDTH-1:0] Y;

assign Y = {B, A};

endmodule