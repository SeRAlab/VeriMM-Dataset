module top_module(
	input clk,
	input rst,
	input ce,
	input we,
	input oe,
	input [7:0] addr,
	input [15:0] di,
	output reg [15:0] doq
);parameter aw = 8; // Address width
parameter dw = 16; // Data width
parameter depth = 256; // Depth of the RAM

reg [dw-1:0] mem [depth-1:0]; // RAM content
reg [aw-1:0] addr_reg; // RAM address register

// Data output drivers
always @(*)
	if (oe)
		doq = mem[addr_reg];
	else
		doq = 16'hxxxx;

// RAM address register
always @(posedge clk or posedge rst)
	if (rst)
		addr_reg <= #1 {aw{1'b0}};
	else if (ce)
		addr_reg <= #1 addr;

// RAM write
always @(posedge clk)
	if (ce && we)
		mem[addr] <= #1 di;

endmodule