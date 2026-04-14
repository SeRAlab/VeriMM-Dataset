module top_module (
	input clk,
	input reset,
	input bit_in,
	output reg [4:0] shift_reg);always @(posedge clk or posedge reset) begin
	if (reset)
		shift_reg <= 5'b0;
	else
		shift_reg <= {shift_reg[3:0], bit_in};
end

endmodule