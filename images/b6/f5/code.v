module top_module (
	input [7:0] input_a, 
	input flag, 
	output reg [7:0] output_signal);always @(*) 
		case (flag)
			0: output_signal = input_a << 2;
			1: output_signal = input_a >> 2;
		endcase
	
endmodule