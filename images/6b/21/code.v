module shift_register(
	input clk,
	input clear,
	input new_bit,
	output [7:0] data);reg [7:0] shift_reg;

	always @(posedge clk)
		if (clear) shift_reg <= 8'b0;
		else shift_reg <= {shift_reg[6:0], new_bit};

	assign data = shift_reg;

endmodule