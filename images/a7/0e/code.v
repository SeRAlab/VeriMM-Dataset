module top_module(
	input [7:0]DEC_2BIT,
	output [3:0]BCD_decade,
	output [3:0]BCD_unit
	);wire [6:0]temp;
	assign temp = DEC_2BIT / 10;
	assign BCD_decade = temp % 10;
	assign BCD_unit = DEC_2BIT % 10;
endmodule