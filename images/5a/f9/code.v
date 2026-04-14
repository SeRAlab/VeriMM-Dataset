module top_module (
	input [3:0] x, 
	input [3:0] y, 
	input [1:0] z, 
	output reg [3:0] w);always @(*) 
		case (z)
			0: w = x & y;
			1: w = x | y;
			2: w = x ^ y;
		endcase
	
endmodule