module top_module(
	input clk,
	input din,
	output reg [3:0] dout);always @(posedge clk) begin
	dout <= {dout[2:0], din};
end
endmodule