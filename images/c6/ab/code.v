module add_subtract(input [3:0] in, output [3:0] out);

	always @ (in) begin
		if (in <= 7) begin
			out = in + 3;
		end else begin
			out = in - 3;
		end
	end

endmodule