module piso_shift_register (
	input clk,
	input reset,
	input load,
	input [7:0] data_in,
	output reg data_out
);reg [7:0] shift_reg;

always @(posedge clk) begin
	if (reset)
		shift_reg <= 8'b00000000;
	else if (load)
		shift_reg <= data_in;
	else
		shift_reg <= shift_reg >> 1;
end

always @(shift_reg) begin
	data_out <= shift_reg[0];
end

endmodule