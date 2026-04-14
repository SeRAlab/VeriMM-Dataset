module top_module(
	bcd,
	seven_seg
);input [3:0] bcd;
output [6:0] seven_seg;

reg [6:0] seven_seg;

always @ (bcd) begin
	case (bcd)
		4'h0:		seven_seg <= 7'b1111110;
		4'h1:		seven_seg <= 7'b0110000;
		4'h2:		seven_seg <= 7'b1101101;
		4'h3:		seven_seg <= 7'b1111001;
		4'h4:		seven_seg <= 7'b0110011;
		4'h5:		seven_seg <= 7'b1011011;
		4'h6:		seven_seg <= 7'b1011111;
		4'h7:		seven_seg <= 7'b1110000;
		4'h8:		seven_seg <= 7'b1111111;
		4'h9:		seven_seg <= 7'b1111011;
		default:	seven_seg <= 7'b0000000;
	endcase
end
endmodule