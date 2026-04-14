module top_module (
	input [3:0] a, 
	input b, 
	output reg [3:0] y);always @(*) 
		case (b)
			0: y = a >> 2;
			1: y = a << 2;
		endcase
	
endmodule