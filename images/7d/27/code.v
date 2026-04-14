module bin_to_gray_2bit (B, G);
input [1:0] B;
output [1:0] G;

assign G[1] = B[1];
assign G[0] = B[1] ^ B[0];

endmodule