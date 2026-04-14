module top_module (
	input [5:0] in,
	output [4:0] out_left,
	output [5:1] out_right,
	output [5:0] out_xor);assign out_left = in & in[5:1];
	assign out_right = in | in[5:1];
	assign out_xor = in^{in[0], in[5:1]};
	
endmodule