module top_module (
	input clk,
	input clrn,
	input [15:0] data,
	output reg [15:0] q);always @(posedge clk or negedge clrn) begin
	if (~clrn)
		q <= 16'b0;
	else
		q <= data;
end

endmodule