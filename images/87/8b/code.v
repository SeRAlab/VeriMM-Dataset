module top_module(
	input clk,
	input reset,
	output reg [3:0] count);
always @(posedge clk) begin
	if (!reset)
		count <= count - 1;
end
	
endmodule