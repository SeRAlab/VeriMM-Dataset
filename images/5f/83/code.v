module top_module (
	input g,
	input h,
	input i,
	output j);assign j = ((g ^ h) & i);
endmodule