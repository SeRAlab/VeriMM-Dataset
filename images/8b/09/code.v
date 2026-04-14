module top_module (
	input clk,
	input resetn,
	input load,
	input [7:0] data,
	output reg [7:0] q);always @(posedge clk or negedge resetn) begin
	if (~resetn)
		q <= 8'b0;
	else if (load)
		q <= data;
end

endmodule