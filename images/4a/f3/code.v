module top_module(
	input clk,
	output reg [3:0] count);always @(posedge clk)
	count <= {count[2:0], count[3]};

endmodule