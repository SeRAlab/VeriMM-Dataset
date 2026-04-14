module top_module(
	input mask_i,
	input [7:0] 			data0_i,
	input [7:0] 			data1_i,
	output [7:0] 			result_o);assign result_o = mask_i ? data1_i : data0_i;
endmodule