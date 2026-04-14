module top_module(
	input clk,
	input load,
	input ena,
	input up_down,
	input [15:0] data,
	output reg [15:0] q);always @(posedge clk) begin
		if (load)
			q <= data;
		else if (ena) begin
			if (up_down)
				q <= q + 1;
			else
				q <= q - 1;
		end
	end
endmodule