module top_module (
	input [11:0] k,
	output [10:0] out_sum,
	output [10:0] out_diff);assign out_sum = k[10:0] + k[11:1];
	assign out_diff = k[10:0] - k[11:1];
	
endmodule