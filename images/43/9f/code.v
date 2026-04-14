module top_module(
	input[15 : 0] rgb16,
	output[23 : 0] rgb24
    );assign rgb24[23 : 16] = {rgb16[15 : 11], rgb16[15 : 13]};
	assign rgb24[15:8] = {rgb16[10 : 5], rgb16[10 : 9]};
	assign rgb24[7:0] = {rgb16[4 : 0], rgb16[4 : 2]};

endmodule