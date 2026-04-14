module top_module(data,a,b,c,d,e,f,g);input [3:0]data;
	output a,b,c,d,e,f,g;
	reg a,b,c,d,e,f,g;
	always@(data)
	begin
		case(data)
			4'b0000:{a,b,c,d,e,f,g} = 7'b1111110;
			4'b0001:{a,b,c,d,e,f,g} = 7'b0110000;
			4'b0010:{a,b,c,d,e,f,g} = 7'b1101101;
			4'b0011:{a,b,c,d,e,f,g} = 7'b1111001;
			4'b0100:{a,b,c,d,e,f,g} = 7'b0110011;
			4'b0101:{a,b,c,d,e,f,g} = 7'b1011011;
			4'b0110:{a,b,c,d,e,f,g} = 7'b1011111;
			4'b0111:{a,b,c,d,e,f,g} = 7'b1110000;
			4'b1000:{a,b,c,d,e,f,g} = 7'b1111111;
			4'b1001:{a,b,c,d,e,f,g} = 7'b1111011;
			4'b1010:{a,b,c,d,e,f,g} = 7'b1110111;
			4'b1011:{a,b,c,d,e,f,g} = 7'b0011111;
			4'b1100:{a,b,c,d,e,f,g} = 7'b1001110;
			4'b1101:{a,b,c,d,e,f,g} = 7'b0111101;
			4'b1110:{a,b,c,d,e,f,g} = 7'b1001111;
			4'b1111:{a,b,c,d,e,f,g} = 7'b1000111;
			default:{a,b,c,d,e,f,g} = 7'b0000000;
		endcase
	end
endmodule