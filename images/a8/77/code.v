module gray_to_bin_5bit (G, B);
input [4:0] G;
output [4:0] B;

assign B[4] = G[4];
assign B[3] = G[4] ^ G[3];
assign B[2] = G[4] ^ G[3] ^ G[2];
assign B[1] = G[4] ^ G[3] ^ G[2] ^ G[1];
assign B[0] = G[4] ^ G[3] ^ G[2] ^ G[1] ^ G[0];

endmodule