module top_module(
    input clk,
    input reset,
    input enable,
    input count_enable,
    input [15:0] data,
    output reg [15:0] q);always @(posedge clk, posedge reset) begin
		if (reset)
			q <= 0;
		else if (enable)
			q <= data;
		else if (count_enable)
			q <= q + 1;
	end
endmodule