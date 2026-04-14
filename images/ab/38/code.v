module top_module (
	input m,
	input n,
	input p,
	output reg q);assign q = (~(m | n)) & p;
endmodule