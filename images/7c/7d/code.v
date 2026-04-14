module top_module (
	input [3:0] a,
	input [3:0] b,
	output [3:0] s,
	output carry_out);wire [4:0] sum = a + b;
	assign s = sum[3:0];
	assign carry_out = sum[4];
	
endmodule