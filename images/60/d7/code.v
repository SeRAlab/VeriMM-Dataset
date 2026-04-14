module top_module (
	input [11:0] h,
	output [11:0] mirror_bits,
	output [3:0] count_ones);assign mirror_bits = {h[0], h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8], h[9], h[10], h[11]};
	assign count_ones = h[0] + h[1] + h[2] + h[3] + h[4] + h[5] + h[6] + h[7] + h[8] + h[9] + h[10] + h[11];
	
endmodule