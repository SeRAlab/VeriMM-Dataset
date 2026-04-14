module top_module (
	input [7:0] in1, 
	input sel, 
	output reg [7:0] y);always @(*) 
		case (sel)
			0: y = in1 << 1;
			1: y = in1 >> 1;
		endcase
	
endmodule