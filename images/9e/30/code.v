module top_module (
	input clk,
	input reset,
	input enable_n,
	output reg [9:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 10'b0;
	else if (!enable_n)
		q <= q + 1;
end

endmodule