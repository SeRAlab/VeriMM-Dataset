module top_module (
	input [3:0] binary, 
	output reg [3:0] gray);always @(*)
	gray = (binary >> 1) ^ binary;
		
endmodule