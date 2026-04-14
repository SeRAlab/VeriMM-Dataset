module top_module(number, segment);input [4:0] number;
	 output [6:0] segment;

	 
	 assign segment =
		(number == 'h0) ? 7'b0000001 :
		(number == 'h1) ? 7'b1001111 :
		(number == 'h2) ? 7'b0010010 :
		(number == 'h3) ? 7'b0000110 :
		(number == 'h4) ? 7'b1001100 :
		(number == 'h5) ? 7'b0100100 :
		(number == 'h6) ? 7'b0100000 :
		(number == 'h7) ? 7'b0001111 :
		(number == 'h8) ? 7'b0000000 :
		(number == 'h9) ? 7'b0000100 :
		(number == 'hA) ? 7'b0001000 :
		(number == 'hB) ? 7'b1100000 :
		(number == 'hC) ? 7'b0110001 :
		(number == 'hD) ? 7'b1000010 :
		(number == 'hE) ? 7'b0110000 :
		(number == 'hF) ? 7'b0111000 :
		                  7'b1111111;

endmodule