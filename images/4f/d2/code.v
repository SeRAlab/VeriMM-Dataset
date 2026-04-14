module top_module (
	input [47:0] in,
	output [46:0] out_both,
	output [47:1] out_any,
	output [47:0] out_different);assign out_both = in & in[47:1];
	assign out_any = in | in[47:1];
	assign out_different = in^{in[0], in[47:1]};
	
endmodule