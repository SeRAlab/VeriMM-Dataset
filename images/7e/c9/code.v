module top_module(
		input [2:0] ilines,
		output [7:0] Tsig
    );reg [7:0] r_reg;
	 
	 always@*
		case(ilines)
			3'h0 : r_reg <= 8'h1;
			3'h1 : r_reg <= 8'h2;
			3'h2 : r_reg <= 8'h4;
			3'h3 : r_reg <= 8'h8;
			3'h4 : r_reg <= 8'h10;
			3'h5 : r_reg <= 8'h20;
			3'h6 : r_reg <= 8'h40;
			3'h7 : r_reg <= 8'h80;
		endcase
		
	assign Tsig = r_reg;

endmodule