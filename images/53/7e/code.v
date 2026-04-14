module top_module (
	input [11:0] f,
	output [11:0] g);

assign g = f - 12'd100;

endmodule