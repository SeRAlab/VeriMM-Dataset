module top_module (
	input clk,
	input reset,
	output reg [9:0] ring);always @(posedge clk) begin
		if (reset)
			ring <= 10'b0000000001;
		else
			ring <= {ring[8:0], ring[9]};
	end

endmodule