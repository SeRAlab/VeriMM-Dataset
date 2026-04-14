module top_module (
	input [7:0] x, 
	input [7:0] y, 
	input s, 
	output reg [7:0] z);always @(*) 
		case (s)
			0: z = x - y;
			1: z = x / y;
		endcase
	
endmodule