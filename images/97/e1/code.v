module top_module (
	input clk,
	input [3:0] addr,
	input [7:0] data_in,
	input we,
	output reg [7:0] data_out);reg [7:0] mem [0:15];
	
	always @(posedge clk) begin
		if (we)
			mem[addr] <= data_in;
		data_out <= mem[addr];
	end
	
endmodule