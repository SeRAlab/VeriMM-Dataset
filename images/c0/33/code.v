module	wbutohex(i_clk, i_stb, i_byte, o_stb, o_valid, o_hexbits);
	input			i_clk, i_stb;
	input		[7:0]	i_byte;
	output	reg		o_stb, o_valid;
	output	reg	[5:0]	o_hexbits;
	always @(posedge i_clk)
		o_stb <= i_stb;
	always @(posedge i_clk)
	begin
		o_valid <= 1'b1;
		o_hexbits <= 6'h00;
		if ((i_byte >= 8'h30)&&(i_byte <= 8'h39)) 
			o_hexbits <= { 2'b0, i_byte[3:0] };
		else if ((i_byte >= 8'h41)&&(i_byte <= 8'h5a)) 
			o_hexbits <= (i_byte[5:0] - 6'h01 + 6'h0a);
		else if ((i_byte >= 8'h61)&&(i_byte <= 8'h7a))
			o_hexbits <= (i_byte[5:0] +6'h03);	
		else if (i_byte == 8'h40) 
			o_hexbits <= 6'h3e;
		else if (i_byte == 8'h25) 
			o_hexbits <= 6'h3f;
		else
			o_valid <= 1'b0;
	end
endmodule