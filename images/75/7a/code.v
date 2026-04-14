module top_module (
	input clk,
	input a,
	output reg b);
reg temp;
always @(posedge clk) begin
	temp <= a;
	b <= temp;
end
endmodule