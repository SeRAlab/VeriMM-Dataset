module top_module (
	input [3:0] a, 
	input [3:0] b, 
	input [1:0] sel, 
	output reg [3:0] out);always @(*) 
		case (sel)
			0: out = a + b;
			1: out = a - b;
			2: out = a * b;
		endcase
	
endmodule