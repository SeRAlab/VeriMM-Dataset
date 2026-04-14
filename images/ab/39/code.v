module top_module(A, B, Y);parameter A_SIGNED = 0;
parameter B_SIGNED = 0;
parameter A_WIDTH = 1;
parameter B_WIDTH = 1;
parameter Y_WIDTH = 1;

input [A_WIDTH-1:0] A;
input [B_WIDTH-1:0] B;
output [Y_WIDTH-1:0] Y;

wire [A_WIDTH+B_WIDTH-1:0] prod;
wire signed [Y_WIDTH-1:0] signed_Y;
wire [Y_WIDTH-1:0] unsigned_Y;

assign prod = A_SIGNED ? {{A[A_WIDTH-1]}, A} : {{1'b0}, A};
assign prod = B_SIGNED ? {{B[B_WIDTH-1]}, B} : {{1'b0}, B};
assign signed_Y = prod[Y_WIDTH-1:0] * prod[2*Y_WIDTH-2:Y_WIDTH-1];
assign unsigned_Y = prod[Y_WIDTH-1:0] * prod[2*Y_WIDTH-2:Y_WIDTH-1];

assign Y = A_SIGNED || B_SIGNED ? signed_Y : unsigned_Y;

endmodule