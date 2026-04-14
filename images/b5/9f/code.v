module top_module(a, b, c, sum, ov);input [3:0] a, b, c;
	output [3:0] sum;
	output ov;

	assign {ov , sum} = a + b + c;endmodule