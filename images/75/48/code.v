module top_module(output [15:0] C, output OverflowFlag,
	input [15:0] A, input [15:0] B, input E);assign OverflowFlag = 1'b0;
	assign C=(E == 1'b1)?(A | B):16'b0000000000000000;

endmodule