module top_module(
	input A,
	input B,
	input Sel,
	output Out
    );assign Out = (Sel==0)?{A}:{B};

endmodule