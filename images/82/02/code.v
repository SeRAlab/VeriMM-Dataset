module top_module(
	
	number,
	
	lowerDigit,
	upperDigit
	);input [7:0] number;
	
	output wire [3:0] lowerDigit;
	output wire [3:0] upperDigit;
	
	assign lowerDigit = number % 10;
	assign upperDigit = number / 10;

endmodule