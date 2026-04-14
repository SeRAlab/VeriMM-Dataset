module conditional_output(
	input wire a,
	input wire b,
	output wire y);assign y = a ? b : 1;

endmodule