module top_module (
	input n,
	input o,
	input p,
	output out_sop,
	output out_pos);assign out_sop = (~n & o & p) | (n & ~o & p) | (n & o & ~p) | (n & o & p);
assign out_pos = (~n | ~o | p) & (n | o | ~p) & (n | o | p);
endmodule