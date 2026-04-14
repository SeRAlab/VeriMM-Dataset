module top_module (
	input [119:0] in,
	output [118:0] out_both,
	output [119:1] out_any,
	output [119:0] out_different);assign out_both = in & in[119:1];
	assign out_any = in | in[119:1];
	assign out_different = in^{in[0], in[119:1]};
	
endmodule