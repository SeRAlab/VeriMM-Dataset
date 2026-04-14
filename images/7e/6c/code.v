module top_module(LED_SEG, DATA_IN);output reg [6:0] LED_SEG;
	
	input [3:0] DATA_IN;
	
	always @(*)
		case(DATA_IN)
			0: LED_SEG <= 7'b1000000;
			1: LED_SEG <= 7'b1111001;
			2: LED_SEG <= 7'b0100100;
			3: LED_SEG <= 7'b0110000;
			4: LED_SEG <= 7'b0011001;
			5: LED_SEG <= 7'b0010010;
			6: LED_SEG <= 7'b0000010;
			7: LED_SEG <= 7'b1111000;
			8: LED_SEG <= 7'b0000000;
			9: LED_SEG <= 7'b0010000;
			10: LED_SEG <= 7'b0001000;
			11: LED_SEG <= 7'b0000011;
			12: LED_SEG <= 7'b1000110;
			13: LED_SEG <= 7'b0100001;
			14: LED_SEG <= 7'b0000110;
			15: LED_SEG <= 7'b0001110;
			default: LED_SEG <= 7'b1111111;
		endcase 
		
endmodule