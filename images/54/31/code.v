module top_module(
	input clk,
	input [9:0] d,
	output reg [9:0] q);

always @(posedge clk) begin
	q <= {d[9], q[9:1]};
end

endmodule