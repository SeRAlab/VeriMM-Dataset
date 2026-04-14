module top_module(
	input clk,
	input reset,
	output reg [8:0] q);wire feedback = q[8] ^ q[4] ^ q[0];
always @(posedge clk) begin
	if (reset)
		q <= 9'b000000001;
	else
		q <= {q[7:0], feedback};
end
endmodule