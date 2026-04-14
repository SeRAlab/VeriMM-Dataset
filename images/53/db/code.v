module ram_4x16 (
	input clk,
	input we,
	input [3:0] addr,
	input [3:0] din,
	output [3:0] dout
);reg [3:0] mem [15:0];
reg [3:0] dout_reg;

always @(posedge clk) begin
	if (we) begin
		mem[addr] <= din;
	end
end

assign dout = mem[addr];

endmodule