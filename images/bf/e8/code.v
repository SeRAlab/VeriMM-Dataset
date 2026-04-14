module	wbudeword(i_clk, i_stb, i_word, i_tx_busy, o_stb, o_nl_hexbits, o_busy);
	input			i_clk, i_stb;
	input		[35:0]	i_word;
	input			i_tx_busy;
	output	reg		o_stb;
	output	reg	[6:0]	o_nl_hexbits;
	output	reg		o_busy;
	wire	[2:0]	w_len;
	assign w_len = (i_word[35:33]==3'b000)? 3'b001
			: (i_word[35:32]==4'h2)? 3'b110
			: (i_word[35:32]==4'h3)? (3'b010+{1'b0,i_word[31:30]})
			: (i_word[35:34]==2'b01)? 3'b010
			: (i_word[35:34]==2'b10)? 3'b001
			:  3'b110;
	reg		r_dly;
	reg	[2:0]	r_len;
	reg	[29:0]	r_word;
	initial o_stb  = 1'b0;
	initial o_busy = 1'b0;
	initial	r_dly  = 1'b0;
	always @(posedge i_clk)
		if ((i_stb)&&(~o_busy)) 
		begin
			r_len <= w_len-3'b001;
			r_word <= i_word[29:0];
			o_stb <= 1'b1;
			o_nl_hexbits <= { 1'b0, i_word[35:30] }; 
			o_busy <= 1'b1;
			r_dly <= 1'b1;
		end else if ((o_stb)&&(i_tx_busy))
		begin
			o_busy <= 1'b1; 
			r_dly <= 1'b1;
		end else if (o_stb) 
			o_stb <= 1'b0; 
		else if (r_len > 0)
		begin
			o_stb <= 1'b1;
			o_nl_hexbits <= { 1'b0, r_word[29:24] };
			r_word[29:6] <= r_word[23:0];
			r_len <= r_len - 3'b001;
			o_busy <= 1'b1; 
			r_dly <= 1'b1;
		end else if (~o_nl_hexbits[6])
		begin
			o_stb <= 1'b1;
			o_nl_hexbits <= 7'h40;
			o_busy <= 1'b1; 
			r_dly <= 1'b1;
		end else begin
			r_dly <= 1'b0;
			o_busy <= (r_dly);
		end
endmodule