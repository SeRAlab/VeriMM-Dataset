module top_module(
	input clk,
	input enable,
	input reset,
	output reg [7:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 8'b1;
	else if (enable)
		q <= {q[6:0], q[7] ^ q[5] ^ q[4]};
end
endmodule