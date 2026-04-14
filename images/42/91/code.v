module top_module(
	input			[4:0] DSP,
	output reg	[3:0] BCD
);always @(DSP) begin
	case(DSP)
		5'b00000: BCD = 4'b1111;	
		5'b10101: BCD = 4'b0000;	
		5'b00011: BCD = 4'b0001;	
		5'b11001: BCD = 4'b0010;	
		5'b11011: BCD = 4'b0011;	
		5'b01111: BCD = 4'b0100;	
		5'b11110: BCD = 4'b0101;	
		5'b11100: BCD = 4'b0110;	
		5'b10011: BCD = 4'b0111;	
		5'b11101: BCD = 4'b1000;	
		5'b11111: BCD = 4'b1001;	
		default:  BCD = 4'b1111;	
	endcase
end


endmodule