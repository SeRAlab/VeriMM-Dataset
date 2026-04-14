module t_flip_flop (
	input clk,
	input reset,
	input t,
	output reg q);always @(posedge clk) begin
	if (reset) begin
		q <= 1'b0;
	end else if (t) begin
		q <= ~q;
	end
end

endmodule