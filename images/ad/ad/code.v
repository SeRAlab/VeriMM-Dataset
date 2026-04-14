module top_module (
	input clk,
	input resetn,
	input d,
	output reg q);always @(posedge clk) begin
	if (~resetn)
		q <= 1'b0;
	else
		q <= d;
end

endmodule