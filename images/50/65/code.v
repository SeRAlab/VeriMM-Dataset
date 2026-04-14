module top_module(
	input clk,
	input reset_n,
	input load,
	input enable,
	input [7:0] data_in,
	output reg [7:0] count);always @(posedge clk) begin
		if (!reset_n)
			count <= 8'b0;
		else if (load)
			count <= data_in;
		else if (enable)
			count <= count + 1;
	end

endmodule