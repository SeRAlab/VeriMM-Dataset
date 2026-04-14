module top_module(
	input clk,
	input reset_n,
	output reg [4:0] q);always @(posedge clk or negedge reset_n) begin
	if (!reset_n)
		q <= 5'b1;
	else
		q <= {q[3:0], q[4] ^ q[2]};
end
endmodule