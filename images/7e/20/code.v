module piso_shift_register(
	input clk,
	input reset_n,
	input load,
	input [7:0] data_in,
	output reg data_out);

reg [7:0] shift_reg;

always @(posedge clk)
	if (!reset_n)
		shift_reg <= 0;
	else if (load)
		shift_reg <= data_in;
	else
		shift_reg <= {shift_reg[6:0], 1'b0};

always @(shift_reg)
	data_out = shift_reg[7];

endmodule