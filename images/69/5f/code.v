module top_module(i_clk, o_led);input	wire		i_clk;
	output	reg	[7:0]	o_led;

	reg	pps;
	reg	[31:0]	time_counter;
	always @(posedge i_clk)
		{ pps, time_counter } <= time_counter + 32'd43;

`ifdef	FASTWALKER
	wire	[2:0]	led_posn;
	assign	led_posn = time_counter[31:29];
`else
	reg	[2:0]	led_posn;
	always @(posedge i_clk)
		if (pps)
			led_posn <= led_posn + 1'b1;
`endif

	always @(posedge i_clk)
	begin
		o_led[0] <= (led_posn == 3'h0);
		o_led[1] <= (led_posn == 3'h1);
		o_led[2] <= (led_posn == 3'h2);
		o_led[3] <= (led_posn == 3'h3);
		o_led[4] <= (led_posn == 3'h4);
		o_led[5] <= (led_posn == 3'h5);
		o_led[6] <= (led_posn == 3'h6);
		o_led[7] <= (led_posn == 3'h7);
	end

endmodule