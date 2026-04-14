module parallel_load_register(
	input clk,
	input clear,
	input load,
	input [7:0] data_in,
	output [7:0] data_out);reg [7:0] reg_data;

	always @(posedge clk)
		if (clear) reg_data <= 8'b0;
		else if (load) reg_data <= data_in;

	assign data_out = reg_data;

endmodule