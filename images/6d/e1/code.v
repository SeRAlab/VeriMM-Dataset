module top_module(w, y);input [3: 0]w;
output [6: 0]y;
reg [6: 0]y;
always @ (w)
	begin
		case(w)
		4'b0000 : y=7'b1111101;
		4'b0001 : y=7'b0110000;
		4'b0010 : y=7'b1101110;
		4'b0011 : y=7'b1111010;
		4'b0100 : y=7'b0110011;
		4'b0101 : y=7'b1011011;
		4'b0110 : y=7'b1011111;
		4'b0111 : y=7'b1110000;
		4'b1000 : y=7'b1111111;
		4'b1001 : y=7'b1111011;
		default : y=7'b0000000;		
		endcase
	end
endmodule