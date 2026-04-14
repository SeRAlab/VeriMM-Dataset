module piso_shift_register(
	input clk,
	input enable,
	input load,
	input [7:0] parallel_in,
	output reg serial_out);reg [7:0] shift_reg;
always @(posedge clk or posedge load) begin
	if (load)
		shift_reg <= parallel_in;
	else if (enable)
		shift_reg <= {shift_reg[6:0], 1'b0};
end

always @(posedge clk or posedge load) begin
	if (load)
		serial_out <= parallel_in[7];
	else if (enable)
		serial_out <= shift_reg[7];
end
endmodule