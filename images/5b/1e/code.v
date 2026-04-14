module top_module(x, cout, sum);input [3:0]x;
	output [1:0]cout;
	output [0:0]sum;
	
	wire [1:0]sum_3;
		
	assign {cout[0], sum_3} = x[0+:2] + x[2+:2];
	
	assign cout[1] = cout[0];
	
	assign sum = {
		sum_3[0]
	};endmodule