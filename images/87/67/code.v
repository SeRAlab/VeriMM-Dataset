module synchronous_ram(
	input clk,
	input [3:0] addr,
	input [7:0] data_in,
	input we,
	output reg [7:0] data_out);reg [7:0] ram[15:0];

always @(posedge clk) begin
    if (we)
        ram[addr] <= data_in;
    data_out <= ram[addr];
end
endmodule