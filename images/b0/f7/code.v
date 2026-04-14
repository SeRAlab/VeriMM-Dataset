module top_module(
	input clk,
	input count_enable,
	input clear,
	output reg [7:0] count);
always @(posedge clk) begin
	if (clear)
		count <= 0;
	else if (count_enable)
		count <= count + 1;
end
	
endmodule