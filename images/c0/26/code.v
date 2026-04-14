module	prefetch(i_clk, i_rst, i_ce, i_stalled_n, i_pc, i_aux,
			o_i, o_pc, o_aux, o_valid, o_illegal,
		o_wb_cyc, o_wb_stb, o_wb_we, o_wb_addr, o_wb_data,
			i_wb_ack, i_wb_stall, i_wb_err, i_wb_data);
	parameter		ADDRESS_WIDTH=32, AUX_WIDTH = 1, AW=ADDRESS_WIDTH;
	input				i_clk, i_rst, i_ce, i_stalled_n;
	input		[(AW-1):0]	i_pc;
	input	[(AUX_WIDTH-1):0]	i_aux;
	output	reg	[31:0]		o_i;
	output	reg	[(AW-1):0]	o_pc;
	output	reg [(AUX_WIDTH-1):0]	o_aux;
	output	reg			o_valid, o_illegal;
	output	reg			o_wb_cyc, o_wb_stb;
	output	wire			o_wb_we;
	output	reg	[(AW-1):0]	o_wb_addr;
	output	wire	[31:0]		o_wb_data;
	input			i_wb_ack, i_wb_stall, i_wb_err;
	input		[31:0]	i_wb_data;
	assign	o_wb_we = 1'b0;
	assign	o_wb_data = 32'h0000;
	initial	o_wb_cyc = 1'b0;
	initial	o_wb_stb = 1'b0;
	initial	o_wb_addr= 0;
	always @(posedge i_clk)
		if ((i_rst)||(i_wb_ack))
		begin
			o_wb_cyc <= 1'b0;
			o_wb_stb <= 1'b0;
		end else if ((i_ce)&&(~o_wb_cyc)) 
		begin
			o_wb_cyc <= 1'b1;
			o_wb_stb <= 1'b1;
		end else if (o_wb_cyc) 
		begin
			if ((o_wb_cyc)&&(o_wb_stb)&&(~i_wb_stall))
				o_wb_stb <= 1'b0;
			if (i_wb_ack)
				o_wb_cyc <= 1'b0;
		end
	always @(posedge i_clk)
		if (i_rst) 
			o_wb_addr <= {(AW){1'b1}};
		else if ((i_ce)&&(~o_wb_cyc))
			o_wb_addr <= i_pc;
	always @(posedge i_clk)
		if ((o_wb_cyc)&&(i_wb_ack))
			o_aux <= i_aux;
	always @(posedge i_clk)
		if ((o_wb_cyc)&&(i_wb_ack))
			o_i <= i_wb_data;
	always @(posedge i_clk)
		if ((o_wb_cyc)&&(i_wb_ack))
			o_pc <= o_wb_addr;
	initial o_valid   = 1'b0;
	initial o_illegal = 1'b0;
	always @(posedge i_clk)
		if ((o_wb_cyc)&&(i_wb_ack))
		begin
			o_valid <= (i_pc == o_wb_addr)&&(~i_wb_err);
			o_illegal <= i_wb_err;
		end else if (i_stalled_n)
		begin
			o_valid <= 1'b0;
			o_illegal <= 1'b0;
		end
endmodule