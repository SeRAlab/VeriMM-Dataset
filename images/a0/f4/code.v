module top_module(
	output O,
	input  I0,
	input  I1
);parameter [1:0] INIT = 0;

	assign O = ((~(I0 & I1)) | (I0 & I1)) ? INIT[1] : INIT[0];

endmodule