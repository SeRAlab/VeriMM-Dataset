module top_module (
	input clk,
	input sync_reset,
	output reg [2:0] q);always @(posedge clk) begin
		if (sync_reset)
			q <= 3'b000;
		else
			q <= q + 1;
	end
	
endmodule