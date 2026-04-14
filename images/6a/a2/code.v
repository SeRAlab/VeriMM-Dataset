module top_module( 
	bin,
	gray) ;output   [4:0]  bin;
	input   [4:0]  gray;

	wire  xor0;
	wire  xor1;
	wire  xor2;
	wire  xor3;

	assign
		bin = {gray[4], xor3, xor2, xor1, xor0},
		xor0 = (gray[0] ^ xor1),
		xor1 = (gray[1] ^ xor2),
		xor2 = (gray[2] ^ xor3),
		xor3 = (gray[4] ^ gray[3]);endmodule