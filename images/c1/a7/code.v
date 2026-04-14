module	hexmap(i_clk, i_hex, o_map);
	input		i_clk;
	input	[3:0]	i_hex;
	output	reg	[7:1]	o_map;
	always @(posedge i_clk)
		case(i_hex)
		4'h0:	o_map <= { 7'b1111110 };
		4'h1:	o_map <= { 7'b0110000 };
		4'h2:	o_map <= { 7'b1101101 };
		4'h3:	o_map <= { 7'b1111001 };
		4'h4:	o_map <= { 7'b0110011 };
		4'h5:	o_map <= { 7'b1011011 };
		4'h6:	o_map <= { 7'b1011111 };
		4'h7:	o_map <= { 7'b1110000 };
		4'h8:	o_map <= { 7'b1111111 };
		4'h9:	o_map <= { 7'b1111011 };
		4'ha:	o_map <= { 7'b1110111 };
		4'hb:	o_map <= { 7'b0011111 }; 
		4'hc:	o_map <= { 7'b1001110 };
		4'hd:	o_map <= { 7'b0111101 }; 
		4'he:	o_map <= { 7'b1001111 };
		4'hf:	o_map <= { 7'b1000111 };
		endcase
endmodule