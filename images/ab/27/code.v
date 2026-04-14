module top_module(A, B, Sel, O);input		[3:0]	A;
	input		[3:0]	B;
	input				Sel;
	output	[3:0] O;

	assign O = Sel ? B : A;

endmodule