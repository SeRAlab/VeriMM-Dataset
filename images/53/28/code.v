module top_module (
	input [3:0] d, 
	input [3:0] e, 
	input [1:0] f, 
	output reg [3:0] g);always @(*) 
		case (f)
			0: g = d + e;
			1: g = d - e;
			2: g = d & e;
		endcase
	
endmodule