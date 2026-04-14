module top_module(
	input [31:0]A,
	input [31:0]B,
	input Sel,
	output [31:0]Out
    );assign Out = (Sel==0)?{A}:{B};
	 
endmodule