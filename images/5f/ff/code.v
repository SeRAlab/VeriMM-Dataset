module decoder3to8 (
	input [2:0] bin_in,
	input enable,
	output [7:0] out
);assign out = (enable) ? (8'b00000001 << bin_in) : 8'b00000000;

endmodule