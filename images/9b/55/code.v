module top_module(input wire [15:0] count, output wire enable);assign enable = !(|(count));

	endmodule