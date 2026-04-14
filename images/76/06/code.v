module top_module(
	input clk,
	input load,
	input shift,
	input reset,
	input [7:0] load_val,
	output reg [7:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 8'b00000000;
	else if (load)
		q <= load_val;
	else if (shift)
		q <= {1'b0, q[7:1]};
end
endmodule