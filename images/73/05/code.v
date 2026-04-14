module latch(
	input d,
	input en,
	output reg q);

	always @(*) begin
		if (en)
			q <= d;
	end
	
endmodule