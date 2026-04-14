module top_module(
	input clk,
	output reg [7:0] count = 8'b11111111);

always @(posedge clk) begin
	count <= count - 1;
end

endmodule