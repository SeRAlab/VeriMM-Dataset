module top_module (
	input [11:0] d,
	output [10:0] out_sum,
	output [10:0] out_and,
	output [11:0] out_xor);assign out_sum = d[10:0] + d[11:1];
	assign out_and = d[10:0] & d[11:1];
	assign out_xor = d ^ {d[0], d[11:1]};
	
endmodule