module top_module (
	input [89:0] in,
	output [88:0] out_both,
	output [89:1] out_any,
	output [89:0] out_different);assign out_both = in & in[89:1];
	assign out_any = in | in[89:1];
	assign out_different = in^{in[0], in[89:1]};
	
endmodule