module top_module(
	input clk,
	input rst,
	input [3:0] height,
	output reg game_pulse
	);reg [31:0] count = 0;
	parameter step = (100000000 - 5000)/10;
	reg [3:0] prevHeight;
	always @(posedge clk) begin
		prevHeight <= height;
		if (rst || prevHeight != height) begin
			count <= 0;
			game_pulse <= 0;
		end else if (count == (100000000 - step * height) - 1) begin
			count <= 0;
			game_pulse <= 1;
		end else begin
			count <= count + 1;
			game_pulse <= 0;
		end
	end
endmodule