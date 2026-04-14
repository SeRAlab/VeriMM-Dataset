module top_module (
	input [24:0] in,
	output [23:0] out_both,
	output [24:1] out_any,
	output [24:0] out_different);assign out_both = in & in[24:1];
	assign out_any = in | in[24:1];
	assign out_different = in^{in[0], in[24:1]};
	
endmodule