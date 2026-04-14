module top_module(
	input clk,
	input enable,
	input reset,
	output reg [7:0] q);always @(posedge clk) begin
	if (reset)
		q <= 8'b00000001;
	else if (enable) begin
		q <= {q[6:0], ~q[7]};
	end
end
endmodule