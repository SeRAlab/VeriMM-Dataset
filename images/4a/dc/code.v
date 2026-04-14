module top_module (
	input [2:0] in,
	output [1:0] out_both,
	output [2:1] out_any,
	output [2:0] out_different);assign out_both = in[1:0] & in[2:1];
	assign out_any = in[1:0] | in[2:1];
	assign out_different = in^{in[0], in[2:1]};
	
endmodule