module top_module(
	input clk,
	input reset_n,
	output reg [11:0] q);always @(posedge clk) begin
	if (!reset_n)
		q <= 12'b1;
	else begin
		q <= {q[10:0], q[11] ^ q[5] ^ q[3] ^ q[0]};
	end
end
endmodule