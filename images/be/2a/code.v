module top_module(
		input En,
		input Clk,
		input D,
		output Q
    );wire notD, nand1, nand2, enQ1, enQ2;

	nand
		g1(notD, D, D),
		g2(nand1, D, Clk),
		g3(nand2, notD, Clk),
		g4(enQ1, nand1, enQ2),
		g5(enQ2, nand2, enQ1);


	assign Q = En ? (enQ1) : 1'bz;


endmodule