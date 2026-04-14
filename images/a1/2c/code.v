module top_module(
    input clk,
    input reset,
    input enable,
    input decrement,
    output reg [1:0] q);always @(posedge clk, posedge reset) begin
		if (reset)
			q <= 0;
		else if (enable) begin
			if (decrement)
				q <= q - 1;
			else
				q <= q + 1;
		end
	end
endmodule