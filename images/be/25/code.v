module top_module (
	input [7:0] a,
	output [11:0] out);assign out = {4'b0000, a};

endmodule