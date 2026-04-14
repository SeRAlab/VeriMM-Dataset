module top_module (
	input [17:0] in,
	output [16:0] out_left,
	output [17:1] out_right,
	output [17:0] out_xor);assign out_left = in & in[17:1];
	assign out_right = in | in[17:1];
	assign out_xor = in^{in[0], in[17:1]};
	
endmodule