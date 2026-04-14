module top_module(
	output Y,
	input A,
	input B
);parameter [3:0] INIT = 4'h0;
	assign Y = INIT >> {B, A};
endmodule