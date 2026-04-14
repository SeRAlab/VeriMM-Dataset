module clk_div4(
	input clk,
	output reg clk_out);reg [1:0] cnt;

always @(posedge clk)
	cnt <= cnt + 1;

assign clk_out = cnt[1];

endmodule