module top_module(
	input clk,
	input reset_n,
	input load,
	input [15:0] d,
	output reg [15:0] q);always @(posedge clk) begin
	if (!reset_n)
		q <= 16'b0;
	else if (load)
		q <= d;
end

endmodule