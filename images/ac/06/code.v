module top_module(
	input wire A,
	input wire B,
	input wire Cin,
	output wire Cout,
	output wire S
	);assign S = ~(A^B^Cin);
	assign Cout = ~(A*B+Cin*(A+B));

endmodule