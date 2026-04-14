module top_module (
	input clk,
	input reset,
	input load,
	input [5:0] load_value,
	output reg [5:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 6'b000000;
	else if (load)
		q <= load_value;
	else
		q <= q + 1;
end

endmodule