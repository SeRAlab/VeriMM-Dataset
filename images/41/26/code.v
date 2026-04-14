module top_module(
	input clk,
	input load,
	input ena,
	input [63:0] data,
	output reg [63:0] q);always @(posedge clk) begin
		if (load)
			q <= data;
		else if (ena)
			q <= q;
	end
endmodule