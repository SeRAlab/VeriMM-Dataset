module top_module(
    input clk,
    input reset,
    input enable,
    input clear,
    input direction,
    output reg [3:0] q);always @(posedge clk, posedge reset) begin
		if (reset)
			q <= 0;
		else if (clear)
			q <= 0;
		else if (enable) begin
			if (direction)
				q <= q + 1;
			else
				q <= q - 1;
		end
	end
endmodule