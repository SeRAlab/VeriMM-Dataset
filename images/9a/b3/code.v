module top_module (
	input [3:0] x, 
	input [3:0] y, 
	input s, 
	output reg [3:0] z);always @(*) 
		case (s)
			0: z = x;
			1: z = y;
		endcase
	
endmodule