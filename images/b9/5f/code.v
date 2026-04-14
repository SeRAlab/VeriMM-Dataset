module mux16to1(
	input [3:0] sel,
	input d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15,
	output y);

	always @(*) begin
		case (sel)
			4'b0000: y = d0;
			4'b0001: y = d1;
			4'b0010: y = d2;
			4'b0011: y = d3;
			4'b0100: y = d4;
			4'b0101: y = d5;
			4'b0110: y = d6;
			4'b0111: y = d7;
			4'b1000: y = d8;
			4'b1001: y = d9;
			4'b1010: y = d10;
			4'b1011: y = d11;
			4'b1100: y = d12;
			4'b1101: y = d13;
			4'b1110: y = d14;
			4'b1111: y = d15;
			default: y = 0;
		endcase
	end
	
endmodule