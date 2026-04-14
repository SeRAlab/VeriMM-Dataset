module piso_shift_register (
	input clk,
	input load,
	input [3:0] parallel_in,
	output reg serial_out);

reg [3:0] shift_reg;

always @(posedge clk) begin
	if (load) begin
		shift_reg <= parallel_in;
	end else begin
		serial_out <= shift_reg[0];
		shift_reg <= shift_reg >> 1;
	end
end

endmodule