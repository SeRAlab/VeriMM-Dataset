module top_module(
    input clk,
    input reset,
    input enable,
    input clear,
    output reg [1:0] q);always @(posedge clk, posedge reset) begin
		if (reset)
			q <= 0;
		else if (clear)
			q <= 0;
		else if (enable)
			q <= q + 1;
	end
endmodule