module top_module(xi, wi, cout, sum);input [31:0]xi;
	input [31:0]wi;
	output [1:0]cout;
	output [7:0]sum;
	
	wire [31:0]xnor_out;
	wire [15:0]sum_3;
	
	assign xnor_out = xi ~^ wi;
	
	assign {cout[0], sum_3} = xnor_out[0+:16] + xnor_out[16+:16];
	
	assign cout[1] = cout[0];
	
	assign sum = {
		sum_3[14], sum_3[12], sum_3[10], sum_3[8], sum_3[6], sum_3[4], sum_3[2], sum_3[0]
	};endmodule