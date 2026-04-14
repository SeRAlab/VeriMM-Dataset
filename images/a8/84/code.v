module top_module (
	input [9:0] in,
	output [8:0] out_sum,
	output [9:1] out_diff,
	output [9:0] out_same);assign out_sum = in & in[9:1];
	assign out_diff = in | in[9:1];
	assign out_same = ~(in^{in[0], in[9:1]});
	
endmodule