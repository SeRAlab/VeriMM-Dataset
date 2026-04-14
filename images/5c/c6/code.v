module top_module(
	input clk,
	input reset,
	input J,
	input K,
	output reg q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 0;
	else if (J && ~K)
		q <= 1;
	else if (~J && K)
		q <= 0;
	else if (J && K)
		q <= ~q;
end

endmodule