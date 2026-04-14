module mux2to1(
	input sel,
	input d0, d1,
	output y);

	always @(*) begin
		case (sel)
			1'b0: y = d0;
			1'b1: y = d1;
			default: y = 0;
		endcase
	end
	
endmodule