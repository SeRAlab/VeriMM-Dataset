module top_module(
	output [7:0] product,
	input [7:0] A,
	input [7:0] B,
	input clk );reg [15:0] prod16;

assign product = prod16[15:8];

always @(posedge clk) begin
	prod16 <= A * B;
end
endmodule