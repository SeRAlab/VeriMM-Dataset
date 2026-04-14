module decoder (
	input [1:0] bin_in,
	input enable,
	output [3:0] out
);assign out = (enable) ? (4'b0001 << bin_in) : 4'b0000;

endmodule