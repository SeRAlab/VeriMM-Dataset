module top_module(sel, input_1, input_2, out);input sel;

	
	input [31:0] input_1;
	input [31:0] input_2;

	
	output reg [31:0] out;

	always @(sel, input_1, input_2) begin
		case(sel)
			0: out <= input_1;
			1: out <= input_2;
		endcase
	end
endmodule