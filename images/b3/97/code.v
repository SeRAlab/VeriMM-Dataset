module top_module(
	input [15:0] data_out,
	input notXor,
	output [31:0] extended
);assign extended [31:16] = (data_out[15] & notXor) ? 16'b1111111111111111 : 16'b0;
	assign extended [15:0] = data_out[15:0];endmodule