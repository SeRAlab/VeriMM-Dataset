module top_module (
	input clk,
	input set,
	input [7:0] data_in,
	output reg [7:0] q);always @(posedge clk) begin
	if (set)
		q <= 8'b11111111;
	else
		q <= data_in;
end

endmodule