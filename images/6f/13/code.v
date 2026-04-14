module top_module (
	input [3:0] p, 
	input [3:0] q, 
	input sel, 
	output reg [3:0] out);always @(*) 
		case (sel)
			0: out = p & q;
			1: out = p | q;
		endcase
	
endmodule