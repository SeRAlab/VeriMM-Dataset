module adder_32bit(
	input wire [31:0] num1,
	input wire [31:0] num2,
	output wire [31:0] sum
);assign sum = num1 + num2;
endmodule