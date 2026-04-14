module top_module (
	input clk,
	input reset,
	input load,
	input [6:0] data,
	output reg [6:0] q);always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 7'b0000000;
		else if (load)
			q <= data;
		else
			q <= q >> 1;
	end
	
endmodule