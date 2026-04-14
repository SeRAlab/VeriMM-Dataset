module binary_counter_sync_reset_enable (
	input clk,
	input reset,
	input enable,
	output reg [1:0] q);

	always @(posedge clk) begin
		if (reset)
			q <= 0;
		else if (enable)
			q <= q + 1;
	end
	
endmodule