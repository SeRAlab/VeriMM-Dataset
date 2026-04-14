module	memops(i_clk, i_rst, i_stb, i_lock,
		i_op, i_addr, i_data, i_oreg,
			o_busy, o_valid, o_err, o_wreg, o_result,
		o_wb_cyc_gbl, o_wb_cyc_lcl,
			o_wb_stb_gbl, o_wb_stb_lcl,
			o_wb_we, o_wb_addr, o_wb_data,
		i_wb_ack, i_wb_stall, i_wb_err, i_wb_data);
	parameter	ADDRESS_WIDTH=24, IMPLEMENT_LOCK=0, AW=ADDRESS_WIDTH;
	input			i_clk, i_rst;
	input			i_stb, i_lock;
	input			i_op;
	input		[31:0]	i_addr;
	input		[31:0]	i_data;
	input		[4:0]	i_oreg;
	output	wire		o_busy;
	output	reg		o_valid;
	output	reg		o_err;
	output	reg	[4:0]	o_wreg;
	output	reg	[31:0]	o_result;
	output	wire		o_wb_cyc_gbl;
	output	reg		o_wb_stb_gbl;
	output	wire		o_wb_cyc_lcl;
	output	reg		o_wb_stb_lcl;
	output	reg		o_wb_we;
	output	reg	[(AW-1):0]	o_wb_addr;
	output	reg	[31:0]	o_wb_data;
	input			i_wb_ack, i_wb_stall, i_wb_err;
	input		[31:0]	i_wb_data;
	reg	r_wb_cyc_gbl, r_wb_cyc_lcl;
	wire	gbl_stb, lcl_stb;
	assign	lcl_stb = (i_stb)&&(i_addr[31:8]==24'hc00000)&&(i_addr[7:5]==3'h0);
	assign	gbl_stb = (i_stb)&&((i_addr[31:8]!=24'hc00000)||(i_addr[7:5]!=3'h0));
	initial	r_wb_cyc_gbl = 1'b0;
	initial	r_wb_cyc_lcl = 1'b0;
	always @(posedge i_clk)
		if (i_rst)
		begin
			r_wb_cyc_gbl <= 1'b0;
			r_wb_cyc_lcl <= 1'b0;
		end else if ((r_wb_cyc_gbl)||(r_wb_cyc_lcl))
		begin
			if ((i_wb_ack)||(i_wb_err))
			begin
				r_wb_cyc_gbl <= 1'b0;
				r_wb_cyc_lcl <= 1'b0;
			end
		end else if (i_stb) 
		begin 
			r_wb_cyc_lcl <= lcl_stb;
			r_wb_cyc_gbl <= gbl_stb;
		end
	always @(posedge i_clk)
		if (o_wb_cyc_gbl)
			o_wb_stb_gbl <= (o_wb_stb_gbl)&&(i_wb_stall);
		else
			o_wb_stb_gbl <= gbl_stb; 
	always @(posedge i_clk)
		if (o_wb_cyc_lcl)
			o_wb_stb_lcl <= (o_wb_stb_lcl)&&(i_wb_stall);
		else
			o_wb_stb_lcl  <= lcl_stb; 
	always @(posedge i_clk)
		if (i_stb)
		begin
			o_wb_we   <= i_op;
			o_wb_data <= i_data;
			o_wb_addr <= i_addr[(AW-1):0];
		end
	initial	o_valid = 1'b0;
	always @(posedge i_clk)
		o_valid <= ((o_wb_cyc_gbl)||(o_wb_cyc_lcl))&&(i_wb_ack)&&(~o_wb_we);
	initial	o_err = 1'b0;
	always @(posedge i_clk)
		o_err <= ((o_wb_cyc_gbl)||(o_wb_cyc_lcl))&&(i_wb_err);
	assign	o_busy = (o_wb_cyc_gbl)||(o_wb_cyc_lcl);
	always @(posedge i_clk)
		if (i_stb)
			o_wreg    <= i_oreg;
	always @(posedge i_clk)
		if (i_wb_ack)
			o_result <= i_wb_data;
	generate
	if (IMPLEMENT_LOCK != 0)
	begin
		reg	lock_gbl, lock_lcl;
		initial	lock_gbl = 1'b0;
		initial	lock_lcl = 1'b0;
		always @(posedge i_clk)
		begin
			lock_gbl <= (i_lock)&&((r_wb_cyc_gbl)||(lock_gbl));
			lock_lcl <= (i_lock)&&((r_wb_cyc_lcl)||(lock_lcl));
		end
		assign	o_wb_cyc_gbl = (r_wb_cyc_gbl)||(lock_gbl);
		assign	o_wb_cyc_lcl = (r_wb_cyc_lcl)||(lock_lcl);
	end else begin
		assign	o_wb_cyc_gbl = (r_wb_cyc_gbl);
		assign	o_wb_cyc_lcl = (r_wb_cyc_lcl);
	end endgenerate
endmodule