module top_module(clk, screenx, screeny, ball_x, ball_y, ball_scan);parameter BALLSIZE=8;
	input clk;
	input [9:0] screenx;
	input [9:0] screeny;
	input [9:0] ball_x;
	input [9:0] ball_y;
	output ball_scan;

	reg [3:0] ballscanX;
	reg 	  ballscanY;

	always @(posedge clk) begin
		if (screenx == ball_x-BALLSIZE/2)
			ballscanX = 12;
		if (ballscanX > 0)
			ballscanX = ballscanX - 1'b1;
	end
	always @(posedge clk) begin
		if (screeny == ball_y-BALLSIZE/2)
			ballscanY = 1;
		if (screeny == ball_y+BALLSIZE/2)
			ballscanY = 0;
	end
	assign ball_scan = ballscanX != 0 && ballscanY;
endmodule