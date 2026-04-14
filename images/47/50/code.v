module top_module (
	input [4:0] a, 
	input [4:0] b, 
	input [4:0] c, 
	input t, 
	output reg [4:0] out);always @(*) 
		case (t)
			0: out = (a & b) ^ c;
			1: out = (a | b) ^ c;
		endcase
	
endmodule