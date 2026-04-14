module top_module(
	input clk,
	input enable,
	input reset,
	output reg [9:0] q);always @(posedge clk) begin
	if (reset)
		q <= 10'b0;
	else if (enable)
		q <= {~q[0], q[9:1]};
end
endmodule