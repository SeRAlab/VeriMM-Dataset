module simple_ram (
	input clk,
	input write_enable,
	input read_enable,
	input [15:0] address,
	input [7:0] data_in,
	output reg [7:0] data_out);reg [7:0] memory [0:65535];
always @(posedge clk) begin
		if (write_enable)
			memory[address] <= data_in;
		if (read_enable)
			data_out <= memory[address];
	end
	
endmodule