module shiftreg (
	input clk,
	input reset,
	input sin,
	output reg [3:0] q
);always @(posedge clk) begin
	if (reset)
		q <= 4'b0000;
	else
		q <= {q[2:0], sin};
end

endmodule