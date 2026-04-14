module top_module (
	input j,
	input k,
	input l,
	output reg m);assign m = ~((j | k) & l);
endmodule