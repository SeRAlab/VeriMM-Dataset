module top_module (
	input [7:0] v, 
	input [7:0] w, 
	input [7:0] u, 
	input ctrl, 
	output reg [7:0] z);always @(*) 
		case (ctrl)
			0: z = (v ^ w) & u;
			1: z = (v & w) | u;
		endcase
	
endmodule