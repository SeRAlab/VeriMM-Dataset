module deppbyte(i_clk,
	i_astb_n, i_dstb_n, i_write_n,i_depp, o_depp, o_wait,
	o_rx_stb, o_rx_data,
	i_tx_stb, i_tx_data, o_tx_busy);
	input	i_clk;
	input			i_astb_n, i_dstb_n, i_write_n;
	input		[7:0]	i_depp;
	output	reg	[7:0]	o_depp;
	output	wire		o_wait;
	output	reg		o_rx_stb;
	output	reg	[7:0]	o_rx_data;
	input			i_tx_stb;
	input		[7:0]	i_tx_data;
	output	reg		o_tx_busy;
	reg	x_dstb_n, x_astb_n, x_write_n,
		r_dstb_n, r_astb_n, r_write_n,
		l_dstb_n, l_astb_n, l_write_n;
	reg	[7:0]	x_depp, r_depp;
	initial	x_dstb_n = 1'b1;
	initial	r_dstb_n = 1'b1;
	initial	l_dstb_n = 1'b1;
	initial	x_astb_n = 1'b1;
	initial	r_astb_n = 1'b1;
	initial	l_astb_n = 1'b1;
	always @(posedge i_clk)
	begin
		{ x_dstb_n, x_astb_n, x_write_n, x_depp }
			<= { i_dstb_n, i_astb_n, i_write_n, i_depp };
		{ r_dstb_n, r_astb_n, r_write_n, r_depp }
			<= { x_dstb_n, x_astb_n, x_write_n, x_depp };
		{ l_dstb_n, l_astb_n, l_write_n } <= { r_dstb_n, r_astb_n, r_write_n };
	end
	reg	[7:0]	addr;
	wire	astb, dstb, w_write;
	assign	astb = (!r_astb_n)&&(l_astb_n);
	assign	dstb = (!r_dstb_n)&&(l_dstb_n);
	assign	w_write= (!r_write_n);
	initial	addr = 8'h00;
	initial	o_rx_stb = 1'b0;
	always @(posedge i_clk)
	begin
		if ((w_write)&&(astb))
			addr <= r_depp;
		if ((w_write)&&(dstb)&&(addr==0))
		begin
			o_rx_stb  <= 1'b1;
			o_rx_data <= r_depp;
		end else
			o_rx_stb <= 1'b0;
	end
	assign	o_wait = ((!i_dstb_n)||(!i_astb_n));
	always @(posedge i_clk)
		o_tx_busy <= ((~l_dstb_n)&&(r_dstb_n)&&(l_write_n)&&(addr == 0))
				? 1'b0 : 1'b1;
	initial	o_depp = 8'hff;
	always @(posedge i_clk)
		if (~o_tx_busy)
			o_depp <= {((i_tx_stb)? i_tx_data[7] : 1'b1),
					i_tx_data[6:0] };
endmodule