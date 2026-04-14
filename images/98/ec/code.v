module top_module (
	input clk,
	input reset_n,
	input [15:0] data_in,
	output reg [15:0] q);always @(posedge clk or negedge reset_n) begin
	if (!reset_n)
		q <= 16'b0;
	else
		q <= data_in;
end

endmodule