module top_module(
	input clk,
	input reset_n,
	output reg [7:0] q);wire feedback = q[7] ^ q[6] ^ q[5] ^ q[0];
always @(posedge clk) begin
	if (!reset_n)
		q <= 8'hFF;
	else
		q <= {q[6:0], feedback};
end
endmodule