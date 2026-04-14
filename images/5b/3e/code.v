module top_module(a, cin, cou, result);input[7:0]	a;
	input		cin;
	output[7:0]	result;
	output		cou;
	
	assign cou = a[0];
	assign result = (a>>1) + (cin<<7);endmodule