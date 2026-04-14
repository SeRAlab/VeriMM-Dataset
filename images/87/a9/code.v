module top_module(
	input clk,
	input load,
	input shift_right,
	input [7:0] data_in,
	output reg [7:0] q);always @(posedge clk) begin
		if (load)
			q <= data_in;
		else if (shift_right)
			q <= {1'b0, q[7:1]};
		else
			q <= {q[6:0], 1'b0};
	end
endmodule