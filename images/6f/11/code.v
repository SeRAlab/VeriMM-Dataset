module top_module(in1, in2, in3, sum, carry);input in1 , in2, in3;
	output sum, carry;
	
	wire in1XORin2;

	assign in1XORin2 = in1 ^ in2;
	assign sum = in1XORin2 ^ in3;
	assign carry = ((in1 & in2) | (in3 &in1XORin2));endmodule