module top_module(input [3:0] a, output reg [6:0] seg);always @ *
	begin
		case(a)
			4'b0000 : seg = 7'b0111111;
			4'b0001 : seg = 7'b0000110;
			4'b0010 : seg = 7'b1011011;
			4'b0011 : seg = 7'b1001111;
			4'b0100 : seg = 7'b1100110;
			4'b0101 : seg = 7'b1101101;
			4'b0110 : seg = 7'b1111101;
			4'b0111 : seg = 7'b0000111;
			4'b1000 : seg = 7'b1111111;
		endcase
	end

	
endmodule