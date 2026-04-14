module top_module(
	input clk,
	input reset,
	input enable,
	input load,
	input [7:0] load_val,
	output reg [7:0] q);always @(posedge clk) begin
	if (~reset)
		q <= 8'b0;
	else if (load)
		q <= load_val;
	else if (enable)
		q <= q + 1;
end

endmodule