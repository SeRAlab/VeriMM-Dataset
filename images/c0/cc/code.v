module	wbuidleint(i_clk, i_stb, i_codword, i_cyc, i_busy, i_int,
		o_stb, o_codword, o_busy,
		i_tx_busy);
	input			i_clk;
	input			i_stb;
	input		[35:0]	i_codword;
	input			i_cyc, i_busy, i_int;
	output	reg		o_stb;
	output	reg	[35:0]	o_codword;
	output	reg		o_busy;
	input			i_tx_busy;
	reg	int_request, int_sent;
	initial	int_request = 1'b0;
	always @(posedge i_clk)
		if((o_stb)&&(~i_tx_busy)&&(o_codword[35:30]==6'h4))
			int_request <= i_int;
		else
			int_request <= (int_request)||(i_int);
	wire		idle_expired;
	reg		idle_state;
	reg	[35:0]	idle_counter;
	initial	idle_counter = 36'h0000;
	always @(posedge i_clk)
		if ((i_stb)||(o_stb))
			idle_counter <= 36'h000;
		else if (~idle_counter[35])
			idle_counter <= idle_counter + 36'd43;
	initial	idle_state = 1'b0;
	always @(posedge i_clk)
		if ((o_stb)&&(~i_tx_busy)&&(o_codword[35:31]==5'h0))
			idle_state <= 1'b1;
		else if (~idle_counter[35])
			idle_state <= 1'b0;
	assign	idle_expired = (~idle_state)&&(idle_counter[35]);
	initial	o_stb  = 1'b0;
	initial	o_busy = 1'b0;
	always @(posedge i_clk)
		if ((o_stb)&&(i_tx_busy))
		begin
			o_busy <= 1'b1;
		end else if (o_stb) 
		begin
			o_stb <= 1'b0;
			o_busy <= 1'b1;
		end else if (o_busy)
			o_busy <= 1'b0;
		else if (i_stb) 
		begin 
			o_codword <= i_codword;
			o_stb <= 1'b1;
			o_busy <= 1'b1;
		end else if ((int_request)&&(~int_sent))
		begin
			o_stb <= 1'b1;
			o_codword <= { 6'h4, 30'h0000 }; 
			o_busy <= 1'b1;
		end else if (idle_expired)
		begin 
			o_stb  <= 1'b1;
			o_busy <= 1'b1;
			if (i_cyc)
				o_codword <= { 6'h1, 30'h0000 }; 
			else
				o_codword <= { 6'h0, 30'h0000 };
		end
	initial	int_sent = 1'b0;
	always @(posedge i_clk)
		if ((int_request)&&((~o_stb)&&(~o_busy)&&(~i_stb)))
			int_sent <= 1'b1;
		else if (~i_int)
			int_sent <= 1'b0;
endmodule