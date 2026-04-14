module top_module(
	output reg [63:0] str,
	input [4:0] r
);always @ (*) begin
		case (r)
			0 : str = "  status";
			1 : str = "     epc";
			2 : str = "badvaddr";
			3 : str = "    evec";
			4 : str = "   count";
			5 : str = " compare";
			6 : str = "   cause";
			7 : str = "    ptbr";
			12: str = "      k0";
			13: str = "      k1";
			30: str = "  tohost";
			31: str = "fromhost";
			default: str = "???";
		endcase
	end
endmodule