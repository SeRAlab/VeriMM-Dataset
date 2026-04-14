module top_module(
	input [7:0] data,
	input enable,
	input load,
	input clk,
	output reg [7:0] q);always @(posedge clk) begin
	if (load)
		q <= data;
	else if (enable)
		q <= {q[6:0], 1'b0};
end
endmodule