module top_module(
	output reg [23:0] str,
	input [4:0] r
);always @ (*) begin
		case (r)
			0 : str = " x0";
			1 : str = " ra";
			2 : str = " s0";
			3 : str = " s1";
			4 : str = " s2";
			5 : str = " s3";
			6 : str = " s4";
			7 : str = " s5";
			8 : str = " s6";
			9 : str = " s7";
			10: str = " s8";
			11: str = " s9";
			12: str = "s10";
			13: str = "s11";
			14: str = " sp";
			15: str = " tp";
			16: str = " v0";
			17: str = " v1";
			18: str = " a0";
			19: str = " a1";
			20: str = " a2";
			21: str = " a3";
			22: str = " a4";
			23: str = " a5";
			24: str = " a6";
			25: str = " a7";
			26: str = " a8";
			27: str = " a9";
			28: str = "a10";
			29: str = "a11";
			30: str = "a12";
			31: str = "a13";
			default: str = "???";
		endcase
	end
endmodule