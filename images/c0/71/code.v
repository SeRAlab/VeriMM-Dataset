module	ziptimer(i_clk, i_rst, i_ce,
		i_wb_cyc, i_wb_stb, i_wb_we, i_wb_data,
			o_wb_ack, o_wb_stall, o_wb_data,
		o_int);
	parameter	BW = 32, VW = (BW-1), RELOADABLE=1;
	input			i_clk, i_rst, i_ce;
	input			i_wb_cyc, i_wb_stb, i_wb_we;
	input	[(BW-1):0]	i_wb_data;
	output	reg			o_wb_ack;
	output	wire			o_wb_stall;
	output	wire	[(BW-1):0]	o_wb_data;
	output	reg		o_int;
	reg			r_running;
	wire	wb_write;
	assign	wb_write = ((i_wb_cyc)&&(i_wb_stb)&&(i_wb_we));
	wire	auto_reload;
	wire	[(VW-1):0]	reload_value;
	initial	r_running = 1'b0;
	always @(posedge i_clk)
		if (i_rst)
			r_running <= 1'b0;
		else if (wb_write)
			r_running <= (|i_wb_data[(VW-1):0]);
		else if ((o_int)&&(~auto_reload))
			r_running <= 1'b0;
	generate
	if (RELOADABLE != 0)
	begin
		reg	r_auto_reload;
		reg	[(VW-1):0]	r_reload_value;
		initial	r_auto_reload = 1'b0;
		always @(posedge i_clk)
			if (wb_write)
				r_auto_reload <= (i_wb_data[(BW-1)]);
		assign	auto_reload = r_auto_reload;
		always @(posedge i_clk)
			if ((wb_write)&&(i_wb_data[(BW-1)])&&(|i_wb_data[(VW-1):0]))
				r_reload_value <= i_wb_data[(VW-1):0];
		assign	reload_value = r_reload_value;
	end else begin
		assign	auto_reload = 1'b0;
		assign	reload_value = 0;
	end endgenerate
	reg	[(VW-1):0]	r_value;
	initial	r_value = 0;
	always @(posedge i_clk)
		if (wb_write)
			r_value <= i_wb_data[(VW-1):0];
		else if ((r_running)&&(i_ce)&&(~o_int))
			r_value <= r_value + {(VW){1'b1}}; 
		else if ((r_running)&&(auto_reload)&&(o_int))
			r_value <= reload_value;
	initial	o_int   = 1'b0;
	always @(posedge i_clk)
		if (i_rst)
			o_int <= 1'b0;
		else if (i_ce)
		o_int <= (r_running)&&(r_value == { {(VW-1){1'b0}}, 1'b1 });
		else
			o_int <= 1'b0;
	initial	o_wb_ack = 1'b0;
	always @(posedge i_clk)
		o_wb_ack <= (i_wb_cyc)&&(i_wb_stb);
	assign	o_wb_stall = 1'b0;
	generate
	if (VW < BW-1)
		assign	o_wb_data = { auto_reload, {(BW-1-VW){1'b0}}, r_value };
	else
		assign	o_wb_data = { auto_reload, r_value };
	endgenerate
endmodule