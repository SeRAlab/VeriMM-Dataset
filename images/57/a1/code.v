module top_module (
	input clk,
	input reset,
	input [15:0] data,
	output reg [15:0] q);always @(posedge clk) begin
	if (reset)
		q <= 16'b0;
	else
		q <= {q[14:0], q[15]};
end

endmodule