module wbufifo(i_clk, i_rst, i_wr, i_data, i_rd, o_data, o_empty_n, o_err);
	parameter	BW=66, LGFLEN=10, FLEN=(1<<LGFLEN);
	input			i_clk, i_rst;
	input			i_wr;
	input	[(BW-1):0]	i_data;
	input			i_rd;
	output	reg [(BW-1):0]	o_data;
	output	reg		o_empty_n;
	output	wire		o_err;
	reg	[(BW-1):0]	fifo[0:(FLEN-1)];
	reg	[(LGFLEN-1):0]	r_first, r_last;
	wire	[(LGFLEN-1):0]	nxt_first;
	assign	nxt_first = r_first+{{(LGFLEN-1){1'b0}},1'b1};
	reg	will_overflow;
	initial	will_overflow = 1'b0;
	always @(posedge i_clk)
		if (i_rst)
			will_overflow <= 1'b0;
		else if (i_rd)
			will_overflow <= (will_overflow)&&(i_wr);
		else if (i_wr)
			will_overflow <= (r_first+2 == r_last);
		else if (nxt_first == r_last)
			will_overflow <= 1'b1;
	initial	r_first = 0;
	always @(posedge i_clk)
		if (i_rst)
			r_first <= { (LGFLEN){1'b0} };
		else if (i_wr)
		begin 
			if ((i_rd)||(~will_overflow)) 
				r_first <= nxt_first;
		end
	always @(posedge i_clk)
		if (i_wr) 
			fifo[r_first] <= i_data;
	reg	will_underflow;
	initial	will_underflow = 1'b0;
	always @(posedge i_clk)
		if (i_rst)
			will_underflow <= 1'b0;
		else if (i_wr)
			will_underflow <= (will_underflow)&&(i_rd);
		else if (i_rd)
			will_underflow <= (r_last+1==r_first);
		else
			will_underflow <= (r_last == r_first);
	initial	r_last = 0;
	always @(posedge i_clk)
		if (i_rst)
			r_last <= { (LGFLEN){1'b0} };
		else if (i_rd)
		begin
			if ((i_wr)||(~will_underflow)) 
				r_last <= r_last+{{(LGFLEN-1){1'b0}},1'b1};
		end
	always @(posedge i_clk)
		o_data <= fifo[(i_rd)?(r_last+{{(LGFLEN-1){1'b0}},1'b1})
					:(r_last)];
	assign	o_err = ((i_wr)&&(will_overflow)&&(~i_rd))
				||((i_rd)&&(will_underflow)&&(~i_wr));
	wire	[(LGFLEN-1):0]	nxt_last;
	assign	nxt_last = r_last+{{(LGFLEN-1){1'b0}},1'b1};
	always @(posedge i_clk)
		if (i_rst)
			o_empty_n <= 1'b0;
		else
			o_empty_n <= (~i_rd)&&(r_first != r_last)
					||(i_rd)&&(r_first != nxt_last);
endmodule