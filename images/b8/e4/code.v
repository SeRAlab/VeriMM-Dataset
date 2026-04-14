module seven_segment_decoder (
	input [3:0] binary,
	output reg [6:0] segments);
	
	always @(*) begin
		case (binary)
			4'b0000: segments = 7'b1111110;
			4'b0001: segments = 7'b0110000;
			4'b0010: segments = 7'b1101101;
			4'b0011: segments = 7'b1111001;
			4'b0100: segments = 7'b0110011;
			4'b0101: segments = 7'b1011011;
			4'b0110: segments = 7'b1011111;
			4'b0111: segments = 7'b1110000;
			4'b1000: segments = 7'b1111111;
			4'b1001: segments = 7'b1111011;
			default: segments = 7'b0000000;
		endcase
	end

endmodule