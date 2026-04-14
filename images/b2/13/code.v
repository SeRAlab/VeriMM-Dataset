module top_module(
		input [31:0] option_a,
		input [31:0] option_b,
		input selector,
		output reg [31:0] out
	);always @*
	begin
		case(selector)
			1'b0:	
				out <= option_a;
			1'b1: 
				out <= option_b;
		endcase
	end
	 
endmodule