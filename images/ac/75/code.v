module top_module(
	input [9:0]x,	input [8:0]y,
	input [9:0]x1, input [8:0]y1, input [9:0]x2, input [8:0]y2,
	output wire d
   );assign d = (x >= x1 && x <= x2 && y>=y1 && y<=y2)? 1'b1 : 1'b0;

endmodule