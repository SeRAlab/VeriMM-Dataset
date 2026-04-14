module top_module(
	input clk,
	input enable,
	input reset,
	output reg [11:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 12'b0000_0000_0001;
	else if (enable)
		q <= {q[10:0], q[11]};
end
endmodule