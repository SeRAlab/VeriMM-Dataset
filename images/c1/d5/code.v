module	wbusixchar(i_clk, i_stb, i_bits, o_stb, o_char, o_busy, i_busy);
	input			i_clk;
	input			i_stb;
	input		[6:0]	i_bits;
	output	reg		o_stb;
	output	reg	[7:0]	o_char;
	output	wire		o_busy;
	input			i_busy;
	initial	o_char = 8'h00;
	always @(posedge i_clk)
		if ((i_stb)&&(~o_busy))
		begin
			if (i_bits[6])
				o_char <= 8'h0a;
			else if (i_bits[5:0] <= 6'h09) 
				o_char <= "0" + { 4'h0, i_bits[3:0] };
			else if (i_bits[5:0] <= 6'd35) 
				o_char <= "A" + { 2'h0, i_bits[5:0] } - 8'd10; 
			else if (i_bits[5:0] <= 6'd61)
				o_char <= "a" + { 2'h0, i_bits[5:0] } - 8'd36;
			else if (i_bits[5:0] == 6'd62) 
				o_char <= 8'h40;
			else 
				o_char <= 8'h25;
		end
	always @(posedge i_clk)
		if ((o_stb)&&(~i_busy))
			o_stb <= 1'b0;
		else if ((i_stb)&&(~o_stb))
			o_stb <= 1'b1;
	assign	o_busy = o_stb;
endmodule