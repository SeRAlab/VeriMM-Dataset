module four_bit_module (
	input	[3:0]	input_data,
	output	[0:0]	output_data
);

	always @(*) begin
		if (input_data == 4'b1010) begin
			output_data = 1;
		end else begin
			output_data = 0;
		end
	end

endmodule