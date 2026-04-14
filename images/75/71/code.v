module top_module(A, B, Y);parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 1;
parameter B_WIDTH = 1;
parameter Y_WIDTH = 1;

input [A_WIDTH-1:0] A;
input [B_WIDTH-1:0] B;
output [Y_WIDTH-1:0] Y;

wire signed [A_WIDTH:0] buffer_a = A_SIGNED ? $signed(A) : A;
wire signed [B_WIDTH:0] buffer_b = B_SIGNED ? $signed(B) : B;

assign Y = buffer_a ** buffer_b;

endmodule