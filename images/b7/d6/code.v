module top_module (
	input [7:0] a, 
	input [7:0] b, 
	input c, 
	output reg [7:0] y);always @(*) 
		case (c)
			0: y = a | b;
			1: y = a ^ b;
		endcase
	
endmodule