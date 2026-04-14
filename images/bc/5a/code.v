module binary_to_bcd (
	input [3:0] bin,
	output reg [6:0] bcd);

	always @(*) begin
		case (bin)
			4'b0000: bcd = 7'b0000000;
			4'b0001: bcd = 7'b0000001;
			4'b0010: bcd = 7'b0000010;
			4'b0011: bcd = 7'b0000011;
			4'b0100: bcd = 7'b0000100;
			4'b0101: bcd = 7'b0000101;
			4'b0110: bcd = 7'b0000110;
			4'b0111: bcd = 7'b0000111;
			4'b1000: bcd = 7'b0001000;
			4'b1001: bcd = 7'b0001001;
			default: bcd = 7'bXXXXXXX;
		endcase
	end
	
endmodule