module top_module(
	input clk,
	input clr,
	input d,
	output reg q);
always @(posedge clk or posedge clr) begin
	if (clr)
		q <= 1'b0;
	else
		q <= d;
end
endmodule