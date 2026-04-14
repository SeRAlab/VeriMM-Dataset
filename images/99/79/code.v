module top_module (
	input [1:0] a,
	input [1:0] b,
	output reg [3:0] product);

always @(*) begin
	product = a * b;
end

endmodule