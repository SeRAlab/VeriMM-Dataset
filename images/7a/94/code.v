module top_module(
	input clk,
	input enable,
	input reset,
	input load,
	input [7:0] load_val,
	output reg [7:0] q);always @(posedge clk or posedge reset or posedge load) begin
	if (reset)
		q <= 8'b00000000;
	else if (load)
		q <= load_val;
	else if (enable)
		q <= q + 1;
end
endmodule