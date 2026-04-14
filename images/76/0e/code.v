module top_module(
	input clk,
	input reset,
	output reg [15:0] q);always @(posedge clk) begin
	if (reset)
		q <= 16'b1;
	else
		q <= {q[14:0], q[15] ^ q[13] ^ q[12] ^ q[10]};
end
endmodule