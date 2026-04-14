module daa (
	input [7:0]flags,
	input [7:0]val,
	output [7:0]adjust,
	output reg cdaa,
	output reg hdaa
	);
	wire h08 = val[7:4] < 9;
	wire h09 = val[7:4] < 10;
	wire l05 = val[3:0] < 6;
	wire l09 = val[3:0] < 10;
	reg [1:0]aa;
	assign adjust = ({1'b0, aa[1], aa[1], 2'b0, aa[0], aa[0], 1'b0} ^ {8{flags[1]}}) + flags[1];
	always @* begin
		case({flags[0], h08, h09, flags[4], l09})
			5'b00101, 5'b01101:	aa = 0;
			5'b00111, 5'b01111, 5'b01000, 5'b01010, 5'b01100, 5'b01110:	aa = 1;
			5'b00001, 5'b01001, 5'b10001, 5'b10101, 5'b11001, 5'b11101:	aa = 2;
			default: aa = 3;
		endcase
		case({flags[0], h08, h09, l09})
			4'b0011, 4'b0111, 4'b0100, 4'b0110:	cdaa = 0;
			default: cdaa = 1;
		endcase
		case({flags[1], flags[4], l05, l09})
			4'b0000, 4'b0010, 4'b0100, 4'b0110, 4'b1110, 4'b1111:	hdaa = 1;
			default:	hdaa = 0;
		endcase
	end
endmodule