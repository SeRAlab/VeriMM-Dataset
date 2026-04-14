module top_module(
	input clk,
	input set,
	input clear,
	output reg [63:0] q);always @(posedge clk) begin
		if (clear)
			q <= 64'b0;
		else if (set)
			q <= 64'b1;
	end
endmodule