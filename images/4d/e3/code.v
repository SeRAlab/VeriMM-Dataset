module top_module(
   input 			[4:0] 	number,
   output reg		[6:0] 	code
   );always @(number)
	begin
		case(number)
			5'b0000: 	code <= ~7'b0111111;
			5'b0001: 	code <= ~7'b0000110;
			5'b0010: 	code <= ~7'b1011011;
			5'b0011: 	code <= ~7'b1001111;
			5'b0100: 	code <= ~7'b1100110;
			5'b0101: 	code <= ~7'b1101101;
			5'b0110: 	code <= ~7'b1111101;
			5'b0111: 	code <= ~7'b0000111;
			5'b1000: 	code <= ~7'b1111111;
			5'b1001: 	code <= ~7'b1101111;
			5'b1010: 	code <= ~7'b1110111;
			5'b1011: 	code <= ~7'b1111100;
			5'b1100: 	code <= ~7'b0111001;
			5'b1101: 	code <= ~7'b1011110;
			5'b1110: 	code <= ~7'b1111001;
			5'b1111: 	code <= ~7'b1110001;
			5'b11111:	code <= ~7'b0000000;
			default: 	code <= ~7'b1000000;
		endcase
	end
	
endmodule