module top_module(x, y, sel, m);input x;
	input y;
	input sel;
	output m;
	
	assign m = (x&~sel) | (y&sel);endmodule