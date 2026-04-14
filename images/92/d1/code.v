module binary_counter_with_pause(
	input clk,
	input pause,
	output reg [3:0] q);
always @(posedge clk) begin
		if (!pause)
			q <= q + 1;
	end
endmodule