module top_module (
	input clk,
	input we,
	input [1:0] addr,
	input [7:0] data_in,
	output reg [7:0] data_out);reg [7:0] regfile [3:0];

always @(posedge clk) begin
		if (we)
			regfile[addr] <= data_in;
		data_out <= regfile[addr];
	end

endmodule