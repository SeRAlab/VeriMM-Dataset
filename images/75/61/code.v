module top_module (
	input [4:0] in,
	output out_all_same,
	output out_none_adj,
	output out_mirror);assign out_all_same = &(~(in[4] ^ in[3] ^ in[2] ^ in[1] ^ in[0]));
	assign out_none_adj = ~(in[4] & in[3]) & ~(in[3] & in[2]) & ~(in[2] & in[1]) & ~(in[1] & in[0]);
	assign out_mirror = (in[4] == in[0]) & (in[3] == in[1]);
	
endmodule