module top_module (
	input clk,
	input resetn,
	input load,
	input [7:0] data,
	output reg [7:0] q);always @(posedge clk or negedge resetn) begin
	if (~resetn)
		q <= 8'b00000000;
	else if (load)
		q <= data;
	else
		q <= {q[6:0], 1'b0};
end

endmodule