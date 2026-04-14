module top_module(
	input[32:0] R0,
	input[32:0] R1,
	input SEL_BUS,
	output[32:0] TO_BUS
	);assign TO_BUS = SEL_BUS? R1:R0;

endmodule