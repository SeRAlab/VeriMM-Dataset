module top_module (
	input [1:0] in,
	output out_both,
	output out_any,
	output out_different);assign out_both = in[0] & in[1];
	assign out_any = in[0] | in[1];
	assign out_different = in[0] ^ in[1];
	
endmodule