module top_module (
	input [31:0] in,
	output [30:0] out_both,
	output [31:1] out_any,
	output [31:0] out_different);assign out_both = in[30:0] & in[31:1];
	assign out_any = in[30:0] | in[31:1];
	assign out_different = in^{in[0], in[31:1]};
	
endmodule