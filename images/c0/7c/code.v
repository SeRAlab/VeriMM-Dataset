module	busdelay(i_clk,
		i_wb_cyc, i_wb_stb, i_wb_we, i_wb_addr, i_wb_data,
			o_wb_ack, o_wb_stall, o_wb_data, o_wb_err,
		o_dly_cyc, o_dly_stb, o_dly_we, o_dly_addr, o_dly_data,
			i_dly_ack, i_dly_stall, i_dly_data, i_dly_err);
	parameter	AW=32, DW=32, DELAY_STALL = 0;
	input	i_clk;
	input				i_wb_cyc, i_wb_stb, i_wb_we;
	input		[(AW-1):0]	i_wb_addr;
	input		[(DW-1):0]	i_wb_data;
	output	reg			o_wb_ack;
	output	wire			o_wb_stall;
	output	reg	[(DW-1):0]	o_wb_data;
	output	wire			o_wb_err;
	output	reg			o_dly_cyc, o_dly_stb, o_dly_we;
	output	reg	[(AW-1):0]	o_dly_addr;
	output	reg	[(DW-1):0]	o_dly_data;
	input				i_dly_ack;
	input				i_dly_stall;
	input		[(DW-1):0]	i_dly_data;
	input				i_dly_err;
	generate
	if (DELAY_STALL != 0)
	begin
		reg	r_stb, r_we, r_rtn_stall, r_rtn_err;
		reg	[(DW-1):0]	r_data;
		reg	[(AW-1):0]	r_addr;
		initial	o_dly_cyc  = 1'b0;
		initial	r_rtn_stall= 1'b0;
		initial	r_stb      = 1'b0;
		always @(posedge i_clk)
		begin
			o_dly_cyc <= (i_wb_cyc);
			if (!i_dly_stall)
			begin
				r_we   <= i_wb_we;
				r_addr <= i_wb_addr;
				r_data <= i_wb_data;
				if (r_stb)
				begin
					o_dly_we   <= r_we;
					o_dly_addr <= r_addr;
					o_dly_data <= r_data;
					o_dly_stb  <= 1'b1;
					r_rtn_stall <= 1'b0;
					r_stb <= 1'b0;
				end else begin
					o_dly_we   <= i_wb_we;
					o_dly_addr <= i_wb_addr;
					o_dly_data <= i_wb_data;
					o_dly_stb  <= i_wb_stb;
					r_stb <= 1'b0;
					r_rtn_stall <= 1'b0;
				end
			end else if ((!r_stb)&&(!o_wb_stall))
			begin
				r_we   <= i_wb_we;
				r_addr <= i_wb_addr;
				r_data <= i_wb_data;
				r_stb  <= i_wb_stb;
				r_rtn_stall <= i_wb_stb;
			end
			if (!i_wb_cyc)
			begin
				o_dly_stb <= 1'b0;
				r_stb <= 1'b0;
				r_rtn_stall <= 1'b0;
			end
			o_wb_ack  <= (i_dly_ack)&&(i_wb_cyc)&&(o_dly_cyc);
			o_wb_data <= i_dly_data;
			r_rtn_err <= (i_dly_err)&&(i_wb_cyc)&&(o_dly_cyc);
		end
		assign	o_wb_stall = r_rtn_stall;
		assign	o_wb_err   = r_rtn_err;
	end else begin
		initial	o_dly_cyc = 1'b0;
		initial	o_dly_stb = 1'b0;
		always @(posedge i_clk)
			o_dly_cyc <= i_wb_cyc;
		always @(posedge i_clk)
			if (~o_wb_stall)
				o_dly_stb <= ((i_wb_cyc)&&(i_wb_stb));
		always @(posedge i_clk)
			if (~o_wb_stall)
				o_dly_we  <= i_wb_we;
		always @(posedge i_clk)
			if (~o_wb_stall)
				o_dly_addr<= i_wb_addr;
		always @(posedge i_clk)
			if (~o_wb_stall)
				o_dly_data <= i_wb_data;
		always @(posedge i_clk)
			o_wb_ack  <= (i_dly_ack)&&(o_dly_cyc)&&(i_wb_cyc);
		always @(posedge i_clk)
			o_wb_data <= i_dly_data;
		assign	o_wb_stall = ((i_dly_stall)&&(o_dly_stb));
		assign	o_wb_err   = i_dly_err;
	end endgenerate
endmodule