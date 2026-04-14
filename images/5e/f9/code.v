module top_module(
    input clk,
    input reset,
    input load,
    input [15:0] data,
    output reg [15:0] q);always @(posedge clk, posedge reset) begin
		if (reset)
			q <= 0;
		else if (load)
			q <= data;
	end
endmodule