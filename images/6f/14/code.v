module bin_to_gray_6bit (B, G);
input [5:0] B;
output [5:0] G;

assign G[5] = B[5];
assign G[4] = B[5] ^ B[4];
assign G[3] = B[4] ^ B[3];
assign G[2] = B[3] ^ B[2];
assign G[1] = B[2] ^ B[1];
assign G[0] = B[1] ^ B[0];

endmodule