module top_module(rda, rdb, a, b, clk);input clk;
	input [31:0] rda, rdb;
	output  [31:0] a, b;
	reg [31:0] a,b;
	always @(posedge clk)
	begin
		 a <= rda;
		 b <= rdb;
	end

endmodule