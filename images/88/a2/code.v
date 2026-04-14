module top_module(clk, ptop, pbot, x, y, scan);parameter H = 0;
	parameter X = 0;
	input clk;
	input [9:0] ptop;
	input [9:0] pbot;
	input [9:0] x;
	input [9:0] y;
	output scan;

	reg [4:0] scanX;
	reg scanY;
	
	always @(posedge clk) begin
		if (x == X) 
			scanX = 16;
		if (scanX > 0)
			scanX = scanX - 1'b1;
	end
	always @(posedge clk) begin
		if (y == ptop)
			scanY = 1;
		if (y >= pbot)
			scanY = 0;
	end
	assign scan = scanX != 0 && scanY;
endmodule