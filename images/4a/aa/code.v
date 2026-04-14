module top_module(
	input clk,
	input load,
	input [9:0] data_in,
	output reg [9:0] q);always @(posedge clk) begin
		if (load)
			q <= data_in;
		else
			q <= {q[8:0], q[9]};
	end
endmodule