module xor_32_refactored(
	input [31:0] a, //input values
	input [31:0] b,
	output [31:0] out //output value
	);

	//output is the XOR of a and b
	assign out = a ^ b;

endmodule