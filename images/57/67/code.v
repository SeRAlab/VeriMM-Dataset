module top_module(
	input [1:0] SW,
	output reg [6:0] HEX0);always @*
		case (SW)
			2'o0:
				HEX0 = 7'b0100000;
			2'o1:
				HEX0 = 7'b1100011;
			2'o2:
				HEX0 = 7'b0000111;
			2'o3:
				HEX0 = 7'b0100011;
		endcase
endmodule