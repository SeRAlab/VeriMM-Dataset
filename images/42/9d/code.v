module top_module(num, out);input [3:0]num;
output reg [6:0] out;

always@(num)begin
    case(num)
	    4'b0000 : out = 7'b1000000;
		4'b0001 : out = 7'b1111001;
        4'b0010 : out = 7'b0100100;
        4'b0011 : out = 7'b0110000;
        4'b0100 : out = 7'b0011001;
        4'b0101 : out = 7'b0010010;
        4'b0110 : out = 7'b0000010;
        4'b0111 : out = 7'b1111000;
        4'b1000 : out = 7'b0000000;
        4'b1001 : out = 7'b0010000;
        4'b1010 : out = 7'b0001000;
        4'b1011 : out = 7'b0000011;
        4'b1100 : out = 7'b0100111;
        4'b1101 : out = 7'b0100001;
        4'b1110 : out = 7'b0000110;
        4'b1111 : out = 7'b0001110;
    endcase
end
endmodule