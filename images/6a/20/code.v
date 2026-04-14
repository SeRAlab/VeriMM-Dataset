module top_module(
	input clk,
	input enable,
	input clear,
	output reg [4:0] count);
always @(posedge clk) begin
	if (clear)
		count <= 0;
	else if (enable)
		count <= count + 1;
end
	
endmodule