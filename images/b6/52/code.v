module top_module (
	input [3:0] a, 
	input [3:0] b, 
	input [1:0] sel, 
	output reg [3:0] q);always @(*) 
		case (sel)
			0: q = a * b;
			1: q = a / b;
			2: q = a % b;
		endcase
	
endmodule