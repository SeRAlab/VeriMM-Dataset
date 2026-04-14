module top_module (
	input [7:0] a, 
	input [7:0] b, 
	input mode, 
	output reg [7:0] y);always @(*) 
		case (mode)
			0: y = a & b;
			1: y = a | b;
		endcase
	
endmodule