module top_module (
	input [3:0] p, 
	input [3:0] q, 
	input [1:0] r, 
	output reg [3:0] s);always @(*) 
		case (r)
			0: s = 1;
			1: s = q;
			2: s = p;
			3: s = p | q;
		endcase
	
endmodule