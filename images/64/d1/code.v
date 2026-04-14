module top_module(
	input e,
	input f,
	output reg g);assign g = ~(e & ~f);

endmodule