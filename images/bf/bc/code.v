module wbdeppsimple(i_clk,
	i_astb_n, i_dstb_n, i_write_n,i_depp, o_depp, o_wait,
	o_wb_cyc, o_wb_stb, o_wb_we, o_wb_addr, o_wb_data,
		i_wb_ack, i_wb_stall, i_wb_err, i_wb_data, i_int);
	input	i_clk;
	input			i_astb_n, i_dstb_n, i_write_n;
	input		[7:0]	i_depp;
	output	reg	[7:0]	o_depp;
	output	wire		o_wait;
	output	reg	o_wb_cyc, o_wb_stb, o_wb_we;
	output	reg	[31:0]	o_wb_addr, o_wb_data;
	input			i_wb_ack, i_wb_stall, i_wb_err;
	input		[31:0]	i_wb_data;
	input			i_int;
	reg	x_dstb_n, x_astb_n, x_write_n,
		r_dstb_n, r_astb_n, r_write_n,
		l_dstb_n, l_astb_n;
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
		{ l_dstb_n, l_astb_n } <= { r_dstb_n, r_astb_n };
	end
	wire	w_wait;
	assign	w_wait = ~(&{x_dstb_n, x_astb_n,
				r_dstb_n, r_astb_n,
				l_dstb_n, l_astb_n});
	reg	[7:0]	addr;
	reg	[31:0]	r_data;
	wire	astb, dstb, w_write;
	assign	astb = (~r_astb_n)&&(l_astb_n);
	assign	dstb = (~r_dstb_n)&&(l_dstb_n);
	assign	w_write= (~r_write_n);
	initial	o_wb_cyc = 1'b0;
	initial	o_wb_stb = 1'b0;
	initial	addr = 8'h00;
	always @(posedge i_clk)
	begin
		if ((w_write)&&(astb))
			addr <= r_depp;
		if ((w_write)&&(dstb)&&(addr[7:3]==5'h00))
		begin
			case(addr[2:0])
			3'b000: o_wb_addr[31:24] <= r_depp;
			3'b001: o_wb_addr[23:16] <= r_depp;
			3'b010: o_wb_addr[15: 8] <= r_depp;
			3'b011: o_wb_addr[ 7: 0] <= r_depp;
			3'b100: o_wb_data[31:24] <= r_depp;
			3'b101: o_wb_data[23:16] <= r_depp;
			3'b110: o_wb_data[15: 8] <= r_depp;
			3'b111: o_wb_data[ 7: 0] <= r_depp;
			endcase
		end
		if ((o_wb_cyc)&&(i_wb_ack)&&(~o_wb_we))
			r_data <= i_wb_data;
		if ((w_write)&&(dstb)&&(|addr[7:3]))
		begin
			o_wb_cyc <= r_depp[0];
			o_wb_stb <= r_depp[0];
			o_wb_we  <= r_depp[1];
		end else begin
			o_wb_stb <= 1'b0;
			if ((o_wb_cyc)&&(i_wb_ack))
				o_wb_cyc <= 1'b0;
		end
	end
	assign	o_wait = (w_wait);
	reg	r_int, r_err;
	initial	r_int = 1'b0;
	initial	r_err = 1'b0;
	always @(posedge i_clk)
	begin
		if (addr[4])
			o_depp <= { 5'h0, o_wb_cyc, r_int, r_err };
		else case(addr[2:0])
		3'b000: o_depp <= o_wb_addr[31:24];
		3'b001: o_depp <= o_wb_addr[23:16];
		3'b010: o_depp <= o_wb_addr[15: 8];
		3'b011: o_depp <= o_wb_addr[ 7: 0];
		3'b100: o_depp <= r_data[31:24];
		3'b101: o_depp <= r_data[23:16];
		3'b110: o_depp <= r_data[15: 8];
		3'b111: o_depp <= r_data[ 7: 0];
		endcase
		r_int <= (i_int)   ||((r_int)&&((~dstb)||(w_write)||(~addr[4])));
		r_err <= (i_wb_err)||((r_err)&&((~dstb)||(w_write)||(~addr[4])));
	end
endmodule