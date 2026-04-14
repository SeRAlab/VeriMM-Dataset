module top_module (
	input [7:0] in1, 
	input [7:0] in2, 
	input sel, 
	output reg [7:0] out);always @(*) 
		case (sel)
			0: out = in1;
			1: out = in2;
		endcase
	
endmodule