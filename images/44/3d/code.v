module adder_16bit(
	input wire [15:0] x,
	input wire [15:0] y,
	output wire [15:0] sum
);assign sum = x + y;
endmodule