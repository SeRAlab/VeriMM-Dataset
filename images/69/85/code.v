module top_module (
	input clk,
	input resetn,
	output reg [7:0] q);always @(posedge clk or negedge resetn) begin
	if (~resetn)
		q <= 8'b11111111;
	else
		q <= q - 1;
end

endmodule