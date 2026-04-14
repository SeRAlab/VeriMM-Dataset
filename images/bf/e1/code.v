module	icontrol(i_clk, i_reset, i_wr, i_proc_bus, o_proc_bus,
		i_brd_ints, o_interrupt);
	parameter	IUSED = 15;
	input			i_clk, i_reset;
	input			i_wr;
	input		[31:0]	i_proc_bus;
	output	wire	[31:0]	o_proc_bus;
	input		[(IUSED-1):0]	i_brd_ints;
	output	wire		o_interrupt;
	reg	[(IUSED-1):0]	r_int_state;
	reg	[(IUSED-1):0]	r_int_enable;
	wire	[(IUSED-1):0]	nxt_int_state;
	reg		r_any, r_interrupt, r_gie;
	assign	nxt_int_state = (r_int_state|i_brd_ints);
	initial	r_int_state = 0;
	always @(posedge i_clk)
		if (i_reset)
			r_int_state  <= 0;
		else if (i_wr)
			r_int_state <= nxt_int_state & (~i_proc_bus[(IUSED-1):0]);
		else
			r_int_state <= nxt_int_state;
	initial	r_int_enable = 0;
	always @(posedge i_clk)
		if (i_reset)
			r_int_enable <= 0;
		else if ((i_wr)&&(i_proc_bus[31]))
			r_int_enable <= r_int_enable | i_proc_bus[(16+IUSED-1):16];
		else if ((i_wr)&&(~i_proc_bus[31]))
			r_int_enable <= r_int_enable & (~ i_proc_bus[(16+IUSED-1):16]);
	initial	r_gie = 1'b0;
	always @(posedge i_clk)
		if (i_reset)
			r_gie <= 1'b0;
		else if (i_wr)
			r_gie <= i_proc_bus[31];
	initial	r_any = 1'b0;
	always @(posedge i_clk)
		r_any <= ((r_int_state & r_int_enable) != 0);
	initial	r_interrupt = 1'b0;
	always @(posedge i_clk)
		r_interrupt <= r_gie & r_any;
	generate
	if (IUSED < 15)
	begin
		assign o_proc_bus = {
				r_gie, { {(15-IUSED){1'b0}}, r_int_enable }, 
				r_any, { {(15-IUSED){1'b0}}, r_int_state  } };
	end else begin
		assign o_proc_bus = { r_gie, r_int_enable, r_any, r_int_state };
	end endgenerate
	assign	o_interrupt = r_interrupt;
endmodule