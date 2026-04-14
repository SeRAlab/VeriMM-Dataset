module top_module(
	input clk,
	input load,
	input [7:0] data_in,
	output [7:0] out);reg [7:0] shift_reg;

	always @(posedge clk) begin
		if (load)
			shift_reg <= data_in;
		else
			shift_reg <= {shift_reg[6:0], 1'b0};
	end

	assign out = shift_reg;

endmodule