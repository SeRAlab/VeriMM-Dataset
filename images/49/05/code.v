module top_module(
	input [3:0] a,
	input [3:0] b,
	output reg gt);

always @(*) begin
	if (a > b)
		gt = 1;
	else
		gt = 0;
end
endmodule