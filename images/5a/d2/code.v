module top_module(
	input clk,
	input reset,
	input data_in,
	input load,
	input [9:0] load_value,
	output reg [9:0] q);always @(posedge clk) begin
		if (reset)
			q <= 10'b0000000000;
		else if (load)
			q <= load_value;
		else
			q <= {q[8:0], data_in};
	end

endmodule