module top_module (
	input [3:0] in1, 
	input [3:0] in2, 
	input en, 
	output reg [3:0] out);always @(*) 
		case (en)
			0: out = in1 | in2;
			1: out = in1 ^ in2;
		endcase
	
endmodule