module top_module(
	clk,
	din_a,
	we_a,
	addr_a,
	dout_b,
	addr_b
);input clk;
input we_a;
input [4:0] addr_a;
input [6:0] din_a;
input [3:0] addr_b;
output [13:0] dout_b;

reg [6:0] lut [0:31];

always @(posedge clk) begin
	if (we_a) begin
		lut[addr_a] <= din_a;
	end
end

assign dout_b = {lut[2*addr_b + 1], lut[2*addr_b]};

endmodule