module top_module (
	input [17:0] in,
	output [16:0] out_both,
	output [17:1] out_any,
	output [17:0] out_different);assign out_both = in[16:0] & in[17:1];
	assign out_any = in[16:0] | in[17:1];
	assign out_different = in^{in[0], in[17:1]};
	
endmodule