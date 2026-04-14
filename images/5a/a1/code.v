module top_module(
	input clk,
	input reset,
	input enable,
	input dir,
	input [13:0] data_in,
	output reg [13:0] shift_reg);always @(posedge clk) begin
		if (reset)
			shift_reg <= 14'b0;
		else if (enable) begin
			if (dir)
				shift_reg <= {shift_reg[12:0], data_in[0]};
			else
				shift_reg <= {data_in[13], shift_reg[13:1]};
		end
	end

endmodule