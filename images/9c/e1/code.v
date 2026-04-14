module top_module(
	input [7:0] data_out,
	input notXor,
	output [31:0] extended
);assign extended [31:8] = (data_out[7] & notXor) ? 24'b111111111111111111111111 : 24'b0;
	assign extended [7:0] = data_out[7:0];endmodule