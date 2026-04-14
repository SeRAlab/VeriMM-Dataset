module top_module(
	input [3:0] numberToDecode,
	output reg [6:0] digitLeds
    );parameter ZERO = 7'b0000001;
parameter ONE = 7'b1001111;
parameter TWO = 7'b0010010;
parameter THREE = 7'b0000110;
parameter FOUR = 7'b1001100;
parameter FIVE = 7'b0100100;
parameter SIX = 7'b0100000;
parameter SEVEN = 7'b0001111;
parameter EIGHT = 7'b0000000;
parameter NINE = 7'b0000100;
parameter showMiddleLed = 7'b0000001;












always @ (numberToDecode)

	begin

		case(numberToDecode)
		
			
			
			
			
			
			
			
			
			
			
			
			
			0: digitLeds = ZERO;
			1: digitLeds = ONE;
			2: digitLeds = TWO;
			3: digitLeds = THREE;
			4: digitLeds = FOUR;
		   5: digitLeds = FIVE;
			6: digitLeds = SIX;
			7: digitLeds = SEVEN;
			8: digitLeds = EIGHT;
			9: digitLeds = NINE;
			
			default:digitLeds = showMiddleLed;
			
		endcase

	end

endmodule