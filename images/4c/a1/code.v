module top_module (
	input clk,
	input resetn,
	input shift,
	input dir,
	output reg [3:0] q);always @(posedge clk or negedge resetn) begin
	if (~resetn)
		q <= 4'b0;
	else if (shift)
		if (dir)
			q <= {q[2:0], 1'b0};
		else
			q <= {1'b0, q[3:1]};
end

endmodule