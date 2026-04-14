module top_module (
	input clk,
	input reset,
	input enable,
	output reg [6:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 7'b1111111;
	else if (enable)
		q <= q - 1;
end

endmodule