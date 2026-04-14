module top_module(
    input clk,
    input clear,
    input enable,
    input load,
    input [15:0] data,
    output reg [15:0] q);always @(posedge clk, posedge clear) begin
		if (clear)
			q <= 0;
		else if (load)
			q <= data;
		else if (enable)
			q <= q;
	end
endmodule