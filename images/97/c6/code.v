module top_module (
	input l, 
	input m, 
	input n, 
	input o,
	output reg k);assign k = l&~m | n&~o | ~l&o;

endmodule