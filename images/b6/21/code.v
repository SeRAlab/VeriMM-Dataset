module top_module (
	input [69:0] in,
	output [68:0] out_both,
	output [69:1] out_any,
	output [69:0] out_different);assign out_both = in & in[69:1];
	assign out_any = in | in[69:1];
	assign out_different = in^{in[0], in[69:1]};
	
endmodule