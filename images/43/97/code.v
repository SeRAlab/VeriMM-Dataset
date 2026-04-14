module top_module(
	output o,
	input a,
	input b,
	input c,
	input d,
	input e,
	input f
);parameter [63:0] INIT = 64'h0;
	parameter EQN = "(A)";
	assign o = INIT >> {f, e, d, c, b, a};
endmodule