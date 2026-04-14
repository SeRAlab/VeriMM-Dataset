module top_module(
		input [20:0] unextended,
		output [31:0] extended
		);assign extended = { {11{unextended[20]}} , unextended};endmodule