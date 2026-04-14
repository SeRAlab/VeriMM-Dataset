module top_module(
	input clk,
	input reset,
	input [11:0] load_value,
	input load,
	input up_down,
	output reg [11:0] q);always @(posedge clk) begin
		if (reset)
			q <= 12'b000000000000;
		else if (load)
			q <= load_value;
		else if (up_down)
			q <= q + 1;
		else
			q <= q - 1;
	end

endmodule