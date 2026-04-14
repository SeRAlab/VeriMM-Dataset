module top_module(a, b, result);input[7:0]	a, b;
	output[7:0]	result;
	assign result = a ^ b;endmodule