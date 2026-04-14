module top_module(a, b, cin, cou, result);input[7:0]	 	a, b;
	input	 		cin;
	output[7:0] 	result;
	output 			cou;
	wire[8:0] 		sum;
	
	assign sum = a + b + cin;
	assign cou = sum[8];
	assign result = sum;endmodule