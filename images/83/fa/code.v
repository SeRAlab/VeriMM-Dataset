module top_module (
	input clk,
	input load,
	input [2:0] data_in,
	output reg [2:0] shift_reg);always @(posedge clk) begin
		if (load)
			shift_reg <= data_in;
		else
			shift_reg <= shift_reg << 1;
	end
	
endmodule