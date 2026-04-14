module top_module(d0, d1, s, y);input		s;
	input		[3:0] d0, d1;
	output	[3:0]	y;
	
	assign	y = (s == 0 ) ? d0 : d1;endmodule