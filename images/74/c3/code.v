module top_module(
	input clk,
	input preset,
	input clear,
	input [9:0] preset_value,
	output reg [9:0] count);
always @(posedge clk) begin
	if (clear)
		count <= 0;
	else if (preset)
		count <= preset_value;
	else
		count <= count - 1;
end
	
endmodule