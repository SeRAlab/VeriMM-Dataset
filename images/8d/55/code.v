module top_module(d0, d1, s, y);input		d0, d1, s;
	output	y;
	assign y = (s == 0) ? d0 : d1;endmodule