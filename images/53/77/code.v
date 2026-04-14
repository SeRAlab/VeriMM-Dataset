module top_module(
    input clk,
    input reset,
    input enable,
    input up_down,
    output reg [2:0] q);always @(posedge clk, posedge reset) begin
		if (reset)
			q <= 3'b000;
		else if (enable) begin
			if (up_down)
				q <= q + 1;
			else
				q <= q - 1;
		end
	end
endmodule