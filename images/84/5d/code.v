module top_module(x, cout, sum);input [31:0]x;
	output [1:0]cout;
	output [7:0]sum;
	
	wire [15:0]sum_3;
		
	assign {cout[0], sum_3} = x[0+:16] + x[16+:16];
	
	assign cout[1] = cout[0];
	
	assign sum = {
		sum_3[14], sum_3[12], sum_3[10], sum_3[8], sum_3[6], sum_3[4], sum_3[2], sum_3[0]
	};endmodule