module top_module(
		input s,
		input [31:0] I0,
		input [31:0] I1,
		output [31:0] o
    );assign o = s ? I1 : I0;

endmodule