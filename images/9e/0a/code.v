module top_module (
	input [7:0] m, 
	input [7:0] n, 
	input [7:0] p, 
	input sel, 
	output reg [15:0] res);always @(*) 
		case (sel)
			0: res = m + n - p;
			1: res = m * n + p;
		endcase
	
endmodule