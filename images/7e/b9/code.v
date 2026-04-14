module synchronous_ram (
	input clk,
	input we,
	input [3:0] read_addr,
	input [3:0] write_addr,
	input [7:0] din,
	output reg [7:0] dout);

	reg [7:0] mem [15:0];

	always @(posedge clk) begin
		if (we)
			mem[write_addr] <= din;
		dout <= mem[read_addr];
	end
endmodule