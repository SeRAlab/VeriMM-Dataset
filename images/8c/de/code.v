module top_module(
	input clk,
	input enable,
	input load,
	input reset,
	input [11:0] load_val,
	output reg [11:0] q);always @(posedge clk) begin
	if (reset)
		q <= 12'b000000000000;
	else if (load)
		q <= load_val;
	else if (enable)
		q <= q + 1;
end
endmodule