module top_module(input [3:0] A, input [3:0] B, input clk, input rst, output reg [3:0] res);always@(posedge clk)
		if(rst) res <= 0;
		else res <= res + A * B;
endmodule