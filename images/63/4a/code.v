module top_module(
	output Y,
	input A
);parameter [1:0] INIT = 2'h0;
	assign Y = INIT >> A;
endmodule