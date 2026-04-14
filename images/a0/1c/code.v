module top_module(       
	input [15:0] i15_0,
	output [31:0] out
);assign out=(i15_0[15])?{16'b1111_1111,i15_0}:{16'b0000_0000,i15_0};endmodule