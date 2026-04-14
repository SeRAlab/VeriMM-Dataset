module top_module (
	input clk,
	input enable,
	input reset,
	input [15:0] data_in,
	output reg [15:0] data_out);always @(posedge clk) begin
		if (reset)
			data_out <= 16'b0;
		else if (enable)
			data_out <= data_in;
	end
	
endmodule