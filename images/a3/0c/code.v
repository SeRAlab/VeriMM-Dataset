module top_module(
	input_1,
	input_2,
	nand_result
);input input_1;
	input input_2;
	output nand_result;

	assign nand_result = !(input_1 & input_2);

endmodule