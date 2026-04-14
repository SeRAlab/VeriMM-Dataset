module bin_to_7seg (
	input [2:0] bin,
	output reg [6:0] seg);always @(*) begin
		case (bin)
			3'b000: seg = 7'b1000000;
			3'b001: seg = 7'b1111001;
			3'b010: seg = 7'b0100100;
			3'b011: seg = 7'b0110000;
			3'b100: seg = 7'b0011001;
			3'b101: seg = 7'b0010010;
			3'b110: seg = 7'b0000010;
			3'b111: seg = 7'b1111000;
			default: seg = 7'b1111111;
		endcase
	end
	
endmodule