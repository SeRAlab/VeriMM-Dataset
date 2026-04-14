module top_module(
	input clk,
	input reset_n,
	input enable,
	input serial_in,
	output reg [11:0] shift_reg);always @(posedge clk) begin
		if (!reset_n)
			shift_reg <= 12'b0;
		else if (enable)
			shift_reg <= {shift_reg[10:0], serial_in};
	end

endmodule