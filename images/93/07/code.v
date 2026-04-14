module top_module (
	input [3:0] p, 
	input [3:0] q, 
	input [1:0] ctrl, 
	output reg [3:0] r);always @(*) 
		case (ctrl)
			0: r = p | q;
			1: r = p & q;
			2: r = p ^ q;
		endcase
	
endmodule