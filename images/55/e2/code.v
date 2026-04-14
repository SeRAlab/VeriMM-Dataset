module top_module(
	output Y,
	input A,
	input B,
	input C
);parameter [7:0] INIT = 8'h0;
	assign Y = INIT >> {C, B, A};
endmodule