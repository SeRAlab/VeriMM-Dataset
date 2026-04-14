module top_module(x,y,z);input x;
	input y;
	output z;
	wire z;
	
	assign z = (x & ~y) | (~x & y);

endmodule