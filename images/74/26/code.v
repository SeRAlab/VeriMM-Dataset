module top_module(
	input clk,
	input load,
	input [4:0] data_in,
	output [4:0] q);reg [4:0] shift_reg = 5'b00000;

	always @(posedge clk) begin
		if (load)
			shift_reg <= data_in;
		else
			shift_reg <= {shift_reg[3:0], 1'b0};
	end

	assign q = shift_reg;

endmodule