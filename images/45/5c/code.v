module top_module(seven_in, seven_out);input [4:0]seven_in;
	output [6:0]seven_out;
	reg [6:0]encoding;

	always @(*) begin
		case(seven_in)
			5'b00000 : encoding <= 7'b0000001; 
			5'b00001 : encoding <= 7'b1001111; 
			5'b00010 : encoding <= 7'b0010010; 
			5'b00011 : encoding <= 7'b0000110; 
			5'b00100 : encoding <= 7'b1001100; 
			5'b00101 : encoding <= 7'b0100100; 
			5'b00110 : encoding <= 7'b0100000; 
			5'b00111 : encoding <= 7'b0001111; 
			5'b01000 : encoding <= 7'b0000000; 
			5'b01001 : encoding <= 7'b0000100; 
			5'b01010 : encoding <= 7'b0110001; 
			5'b01011 : encoding <= 7'b1110001; 
			5'b01100 : encoding <= 7'b0100100; 
			5'b01101 : encoding <= 7'b1000010; 
			5'b01110 : encoding <= 7'b0000001; 
			5'b01111 : encoding <= 7'b0011000; 
			5'b10000 : encoding <= 7'b0110000; 
			5'b10001 : encoding <= 7'b1101010; 
			5'b10010 : encoding <= 7'b1111110; 
			5'b10011 : encoding <= 7'b1111111; 
		endcase
	end
	
	assign seven_out = encoding;

endmodule