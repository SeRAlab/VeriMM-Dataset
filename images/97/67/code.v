module top_module(hexadecimal,a,b,c,d,e,f,g);input[3:0] hexadecimal;

     
     output reg a,b,c,d,e,f,g;
     
     
     always @(hexadecimal)
          case (hexadecimal)
			4'b0000: {a,b,c,d,e,f,g} = 7'b0000001;
			4'b0001: {a,b,c,d,e,f,g} = 7'b1001111;
			4'b0010: {a,b,c,d,e,f,g} = 7'b0010010;
			4'b0011: {a,b,c,d,e,f,g} = 7'b0000110;
			4'b0100: {a,b,c,d,e,f,g} = 7'b1001100;
			4'b0101: {a,b,c,d,e,f,g} = 7'b0100100;
			4'b0110: {a,b,c,d,e,f,g} = 7'b0100000;
			4'b0111: {a,b,c,d,e,f,g} = 7'b0001111;
			4'b1000: {a,b,c,d,e,f,g} = 7'b0000000;
			4'b1001: {a,b,c,d,e,f,g} = 7'b0000100;
			4'b1010: {a,b,c,d,e,f,g} = 7'b0001000;
			4'b1011: {a,b,c,d,e,f,g} = 7'b1100000;
			4'b1100: {a,b,c,d,e,f,g} = 7'b0110001;
			4'b1101: {a,b,c,d,e,f,g} = 7'b1000010;
			4'b1110: {a,b,c,d,e,f,g} = 7'b0110000;
			4'b1111: {a,b,c,d,e,f,g} = 7'b0111000;
			default: {a,b,c,d,e,f,g} = 7'b1111111;
		endcase
endmodule