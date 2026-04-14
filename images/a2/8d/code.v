module top_module (
	input [1:0] e,
	input [1:0] f,
	input [1:0] g,
	output [1:0] h);assign h = ~(e & f & g);

endmodule