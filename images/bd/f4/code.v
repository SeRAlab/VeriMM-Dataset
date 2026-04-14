module decoder2to4(
	input [1:0] a,
	output reg y0, y1, y2, y3);

	always @(*) begin
		case (a)
			2'b00: {y0, y1, y2, y3} = 4'b0001;
			2'b01: {y0, y1, y2, y3} = 4'b0010;
			2'b10: {y0, y1, y2, y3} = 4'b0100;
			2'b11: {y0, y1, y2, y3} = 4'b1000;
			default: {y0, y1, y2, y3} = 4'b0000;
		endcase
	end
	
endmodule