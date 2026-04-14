module top_module(input [15:0] A, B,
		output [15:0] out);assign out = ~(A|B);endmodule