module top_module (
	input [3:0] x, 
	input [3:0] y, 
	input [1:0] z, 
	output reg [3:0] r);always @(*) 
		case (z)
			0: r = 0;
			1: r = y;
			2: r = x;
			3: r = x + y;
		endcase
	
endmodule