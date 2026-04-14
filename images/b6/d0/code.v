module top_module (
	input in1, 
	input in2, 
	input mode, 
	output reg out);always @(*) 
		case (mode)
			0: out = in1 && in2;
			1: out = in1 || in2;
		endcase
	
endmodule