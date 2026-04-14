module top_module(
	input clk,
	input reset,
	output reg [4:0] count);always @(posedge clk)
	if (reset)
		count <= 5'b00000;
	else
		count <= {~count[0], count[4:1]};

endmodule