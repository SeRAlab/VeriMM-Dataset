module top_module(
	input clk,
	input ena,
	input [11:0] data,
	output reg [11:0] q);always @(posedge clk) begin
		if (ena)
			q <= {q[10:0], q[11]};
	end
endmodule