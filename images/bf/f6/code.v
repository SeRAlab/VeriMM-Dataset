module	wbucompactlines(i_clk, i_stb, i_nl_hexbits, o_stb, o_nl_hexbits,
		i_bus_busy, i_tx_busy, o_busy);
	input	i_clk, i_stb;
	input	[6:0]	i_nl_hexbits;
	output	reg	o_stb;
	output	reg	[6:0]	o_nl_hexbits;
	input			i_bus_busy;
	input			i_tx_busy;
	output	wire		o_busy;
	reg	last_out_nl, last_in_nl;
	initial	last_out_nl = 1'b1;
	initial	last_in_nl = 1'b1;
	always @(posedge i_clk)
		if ((~i_tx_busy)&&(o_stb))
			last_out_nl <= (o_nl_hexbits[6]);
	always @(posedge i_clk)
		if ((i_stb)&&(~o_busy))
			last_in_nl <= (i_nl_hexbits[6]);
	reg	[6:0]	linelen;
	initial	linelen = 7'h00;
	always @(posedge i_clk)
		if ((~i_tx_busy)&&(o_stb))
		begin
			if (o_nl_hexbits[6])
				linelen <= 0;
			else
				linelen <= linelen + 7'h1;
		end
	reg	full_line;
	initial	full_line = 1'b0;
	always @(posedge i_clk)
		full_line <= (linelen > 7'd72);
	initial	o_stb = 1'b0;
	always @(posedge i_clk)
		if ((i_stb)&&(~o_busy))
		begin
			o_stb <= (full_line)||(~i_nl_hexbits[6]);
			o_nl_hexbits <= i_nl_hexbits;
		end else if (~o_busy)
		begin
			o_stb <= (~i_tx_busy)&&(~i_bus_busy)&&(~last_out_nl)&&(last_in_nl);
			o_nl_hexbits <= 7'h40;
		end else if (~i_tx_busy)
			o_stb <= 1'b0;
	reg	r_busy;
	initial	r_busy = 1'b0;
	always @(posedge i_clk)
		r_busy <= (o_stb);
	assign	o_busy = (r_busy)||(o_stb);
endmodule