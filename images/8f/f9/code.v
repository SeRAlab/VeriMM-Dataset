module top_module (
	input [14:0] i,
	output [13:0] out_sum,
	output [13:0] out_or,
	output [14:0] out_xor);assign out_sum = i[13:0] + i[14:1];
	assign out_or = i[13:0] | i[14:1];
	assign out_xor = i ^ {i[0], i[14:1]};
	
endmodule