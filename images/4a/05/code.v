module top_module(blank, hcount, vcount, moonX, moonY, moon);input blank;
	input signed [10:0] hcount, vcount;
	input signed [11:0] moonX, moonY;
	output moon;
	
	
	
	assign moon = ~blank & (((hcount-moonX)*(hcount-moonX) + (vcount-moonY)*(vcount-moonY)) <= 1224);






endmodule