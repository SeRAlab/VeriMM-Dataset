module top_module(BAUD, k);input 	    [3:0]	BAUD; 
	output reg  [18:0]	k; 
	
	
	parameter 	BAUD_0  = 4'b0000, 
			BAUD_1  = 4'b0001, 
			BAUD_2  = 4'b0010, 
			BAUD_3  = 4'b0011, 
			BAUD_4  = 4'b0100,
			BAUD_5  = 4'b0101,
			BAUD_6  = 4'b0110,
			BAUD_7  = 4'b0111,
			BAUD_8  = 4'b1000,
			BAUD_9  = 4'b1001,
			BAUD_10 = 4'b1010,
			BAUD_11 = 4'b1011;
	
	
	always@(*)begin
		case(BAUD)
			BAUD_0 	: k = 19'd333333;
			BAUD_1 	: k = 19'd83333;
			BAUD_2 	: k = 19'd41667;
			BAUD_3 	: k = 19'd20833;
			BAUD_4 	: k = 19'd10417;
			BAUD_5 	: k = 19'd5208;
			BAUD_6 	: k = 19'd2604;
			BAUD_7 	: k = 19'd1736;
			BAUD_8 	: k = 19'd868;
			BAUD_9 	: k = 19'd434;
			BAUD_10 : k = 19'd217;
			BAUD_11 : k = 19'd109;
			default	: k = 19'b0;
		endcase
	end

endmodule