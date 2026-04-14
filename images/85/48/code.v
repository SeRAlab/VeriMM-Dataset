module top_module (
	input [3:0] a, 
	input b, 
	output reg [3:0] c);always @(*) 
		case (b)
			0: c = a << 1;
			1: c = a >> 1;
		endcase
	
endmodule