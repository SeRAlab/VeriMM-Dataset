module top_module(
	input clk,
	input reset_n,
	input load,
	input [3:0] data_in,
	output reg [3:0] count);always @(posedge clk) begin
		if (!reset_n)
			count <= 4'b0000;
		else if (load)
			count <= data_in;
		else
			count <= count + 1;
	end

endmodule