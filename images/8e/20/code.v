module top_module (
	input [11:0] in,
	output [10:0] out_both,
	output [11:1] out_any,
	output [11:0] out_different);assign out_both = in & in[11:1];
	assign out_any = in | in[11:1];
	assign out_different = in^{in[0], in[11:1]};
	
endmodule