module top_module (
	input [5:0] m, 
	input [5:0] n, 
	input control, 
	output reg [5:0] result);always @(*) 
		case (control)
			0: result = m ^ n;
			1: result = ~m;
		endcase
	
endmodule