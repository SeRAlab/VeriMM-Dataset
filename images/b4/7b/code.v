module top_module (
	input [35:0] in,
	output [34:0] out_both,
	output [35:1] out_any,
	output [35:0] out_different);assign out_both = in & in[35:1];
	assign out_any = in | in[35:1];
	assign out_different = in^{in[0], in[35:1]};
	
endmodule