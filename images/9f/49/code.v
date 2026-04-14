module top_module (
	input [3:0] a, 
	input [3:0] b, 
	input [1:0] c, 
	output reg [3:0] d);always @(*) 
		case (c)
			0: d = a - b;
			1: d = a + b;
			2: d = a * b;
		endcase
	
endmodule