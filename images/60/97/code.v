module top_module (
	input clk,
	input reset_n,
	input shift,
	input [15:0] data_in,
	output reg [15:0] shift_reg);always @(posedge clk) begin
	if (!reset_n)
		shift_reg <= 16'b0;
	else if (shift)
		shift_reg <= {shift_reg[14:0], data_in[15]};
end

endmodule