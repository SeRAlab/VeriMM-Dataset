module top_module(clk, nonce, true_nonce);input clk;
   input [31:0] nonce;
	output [31:0] true_nonce;

	reg[31:0] cnt;

	wire [31:0] rev_nonce;
	wire [31:0] new_nonce;

	assign rev_nonce = { nonce[0], nonce[1], nonce[2], nonce[3], nonce[4], nonce[5], nonce[6], nonce[7],
								nonce[8], nonce[9], nonce[10], nonce[11], nonce[12], nonce[13], nonce[14], nonce[15],
								nonce[16], nonce[17], nonce[18], nonce[19], nonce[20], nonce[21], nonce[22], nonce[23],
								nonce[24], nonce[25], nonce[26], nonce[27], nonce[28], nonce[29], nonce[30], nonce[31]
								};
	assign new_nonce = rev_nonce - 32'hc0;

	assign true_nonce = new_nonce;
	
	
	
endmodule