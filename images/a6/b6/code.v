module top_module (
	input [15:0] b,
	output [14:0] out_sum,
	output [14:0] out_or,
	output [15:0] out_xor);assign out_sum = b[14:0] + b[15:1];
	assign out_or = b[14:0] | b[15:1];
	assign out_xor = b ^ {b[0], b[15:1]};
	
endmodule