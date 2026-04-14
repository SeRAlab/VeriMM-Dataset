module top_module(
	input clk,
	input enable,
	input load,
	input reset,
	input [9:0] load_value,
	output reg [9:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 10'b0;
	else if (load)
		q <= load_value;
	else if (enable)
		q <= q + 1;
end
endmodule