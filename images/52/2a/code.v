module top_module(
	input clk,
	input reset,
	input load,
	input enable,
	input [7:0] data_in,
	output reg [7:0] shift_reg);

always @(posedge clk) begin
		if (reset)
			shift_reg <= 8'b00000000;
		else if (load)
			shift_reg <= data_in;
		else if (enable)
			shift_reg <= {shift_reg[6:0], 1'b0};
	end
	
endmodule