module top_module (
	input [23:0] in,
	output [22:0] out_left,
	output [23:1] out_right,
	output [23:0] out_xor);assign out_left = in & in[23:1];
	assign out_right = in | in[23:1];
	assign out_xor = in^{in[0], in[23:1]};
	
endmodule