module top_module (
	input k,
	input l,
	output reg m);assign m = ~(~k | l);
endmodule