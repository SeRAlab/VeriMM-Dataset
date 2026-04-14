module top_module (
	input [3:0] x, 
	input [3:0] y, 
	input [1:0] ctrl, 
	output reg [3:0] z);always @(*) 
		case (ctrl)
			0: z = x & y;
			1: z = x | y;
			2: z = x ^ y;
		endcase
	
endmodule