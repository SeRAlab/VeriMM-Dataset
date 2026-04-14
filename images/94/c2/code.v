module top_module(
	input clk, reset,
	input [63:0] PC_In,
	output reg [63:0] PC_Out
);always@(posedge clk)
		if (reset != 1)
			PC_Out = PC_In;
	always@(reset)
		PC_Out = 64'd0;

endmodule