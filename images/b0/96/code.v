module top_module(SW,HEX0);input [2:0]SW;
	output reg [0:6]HEX0;
	
	always @(SW)
		case (SW)
			3'b000 : HEX0 = 7'b0001001;
			3'b001 : HEX0 = 7'b0000110;
			3'b010 : HEX0 = 7'b1000111;
			3'b011 : HEX0 = 7'b1000000;
			3'b100 : HEX0 = 7'b1111111;
			3'b101 : HEX0 = 7'b1111111;
			3'b110 : HEX0 = 7'b1111111;
			3'b111 : HEX0 = 7'b1111111;
		endcase	
	
		
endmodule