module mux_2to1(input A, B, SEL, output reg Y);
	always @ (SEL) begin
		if (SEL == 1) begin
			Y <= B;
		end
		else begin
			Y <= A;
		end
	end
endmodule