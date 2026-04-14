module top_module(
	input clk,
	input load,
	input [7:0] data_in,
	output [7:0] data_out);logic [7:0] reg_value;

	always @(posedge clk)
		if (load) reg_value <= data_in;

	assign data_out = reg_value;

endmodule