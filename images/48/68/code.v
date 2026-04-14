module top_module(sin, sout);input [3:0]sin;
output [6:0]sout;
reg [6:0]sout;
always@(sin)
begin
	case(sin)
		4'b 0000:sout=7'b 1000000;
		4'b 0001:sout=7'b 1111001;
		4'b 0010:sout=7'b 0100100;
		4'b 0011:sout=7'b 0110000;
		4'b 0100:sout=7'b 0011001;
		4'b 0101:sout=7'b 0010010;
		4'b 0110:sout=7'b 0000010;
		4'b 0111:sout=7'b 1111000;
		4'b 1000:sout=7'b 0000000;
		4'b 1001:sout=7'b 0010000;
		4'b 1010:sout=7'b 0001000;
		4'b 1011:sout=7'b 0000011;
		4'b 1100:sout=7'b 1000110;
		4'b 1101:sout=7'b 0100001;
		4'b 1110:sout=7'b 0000110;
		4'b 1111:sout=7'b 0001110;
	endcase
end
endmodule