module	wbwatchdog(i_clk, i_rst, i_ce, i_timeout, o_int);
	parameter	BW = 32;
	input			i_clk, i_rst, i_ce;
	input	[(BW-1):0]	i_timeout;
	output	reg		o_int;
	reg	[(BW-1):0]	r_value;
	initial	r_value = 0;
	always @(posedge i_clk)
		if (i_rst)
			r_value <= i_timeout[(BW-1):0];
		else if ((i_ce)&&(~o_int))
			r_value <= r_value + {(BW){1'b1}}; 
	initial	o_int   = 1'b0;
	always @(posedge i_clk)
		if ((i_rst)||(~i_ce))
			o_int <= 1'b0;
		else
			o_int <= (r_value == { {(BW-1){1'b0}}, 1'b1 });
endmodule