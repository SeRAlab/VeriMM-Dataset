module top_module(
	input clk,
	input reset,
	input load,
	input [2:0] data_in,
	output reg [2:0] data_out);always @(posedge clk) begin
		if (reset)
			data_out <= 3'b000;
		else if (load)
			data_out <= data_in;
		else
			data_out <= {data_out[1:0], 1'b0};
	end

endmodule