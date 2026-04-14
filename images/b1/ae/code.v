module shift_reg5 (
	input clk,
	input shift,
	input [4:0] d,
	output reg [4:0] q
);always @(posedge clk) begin
	if (shift)
		q <= {q[3:0], d[4]};
end

endmodule