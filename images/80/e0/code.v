module top_module(In0, Out0);input [3:0] In0;
	output reg[0:6] Out0;
	
	always @(In0)
	begin
		case(In0)
			4'b0000: Out0 = 7'b0000001;
			4'b0001: Out0 = 7'b1001111;
			4'b0010: Out0 = 7'b0010010;
			4'b0011: Out0 = 7'b0000110;
			4'b0100: Out0 = 7'b1001100;
			4'b0101: Out0 = 7'b0100100;
			4'b0110: Out0 = 7'b0100000;
			4'b0111: Out0 = 7'b0001101;
			4'b1000: Out0 = 7'b0000000;
			4'b1001: Out0 = 7'b0000100;
			4'b1010: Out0 = 7'b0001000;
			4'b1011: Out0 = 7'b1100000;
			4'b1100: Out0 = 7'b0110001;
			4'b1101: Out0 = 7'b1000010;
			4'b1110: Out0 = 7'b0110000;
			4'b1111: Out0 = 7'b0111000;
		endcase
	end
endmodule