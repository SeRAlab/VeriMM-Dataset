module top_module(xi, wi, cout, sum);input [127:0]xi;
	input [127:0]wi;
	output [1:0]cout;
	output [31:0]sum;
	
	wire [127:0]xnor_out;
	wire [63:0]sum_3;
	
	assign xnor_out = xi ~^ wi;
	
	assign {cout[0], sum_3} = xnor_out[0+:64] + xnor_out[64+:64];
	
	assign cout[1] = cout[0];
	
	assign sum = {
		sum_3[62], sum_3[60], sum_3[58], sum_3[56], sum_3[54], sum_3[52], sum_3[50], sum_3[48], 
		sum_3[46], sum_3[44], sum_3[42], sum_3[40], sum_3[38], sum_3[36], sum_3[34], sum_3[32], 
		sum_3[30], sum_3[28], sum_3[26], sum_3[24], sum_3[22], sum_3[20], sum_3[18], sum_3[16], 
		sum_3[14], sum_3[12], sum_3[10], sum_3[8], sum_3[6], sum_3[4], sum_3[2], sum_3[0]
	};endmodule