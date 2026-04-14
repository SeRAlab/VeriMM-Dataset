module binary_to_gray(BIN, GRAY);
input [3:0] BIN;
output [3:0] GRAY;

assign GRAY[3] = BIN[3];
assign GRAY[2] = BIN[3] ^ BIN[2];
assign GRAY[1] = BIN[2] ^ BIN[1];
assign GRAY[0] = BIN[1] ^ BIN[0];

endmodule