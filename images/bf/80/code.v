module shift_register (
	input clk,
	input shift_en,
	input load_en,
	input [7:0] parallel_in,
	output reg serial_out
);

reg [7:0] shift_reg;

always @(posedge clk) begin
	if (load_en) begin
		shift_reg <= parallel_in;
	end else if (shift_en) begin
		shift_reg <= {1'b0, shift_reg[7:1]};
	end
	serial_out <= shift_reg[0];
end

endmodule