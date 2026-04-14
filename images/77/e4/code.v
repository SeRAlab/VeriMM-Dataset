module top_module(inputImed, outputImed);input [16:0] inputImed;
	output [31:0] outputImed;
	wire [31:0] positive, negative;
	
	assign positive = {15'b000000000000000, inputImed};
	assign negative = {15'b111111111111111, inputImed};
	
	wire sign;
	assign sign = inputImed[16];
	
	assign outputImed = sign ? negative : positive;endmodule