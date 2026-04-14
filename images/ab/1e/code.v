module top_module(
	input clk,
	input enable,
	input preset,
	input [13:0] preset_value,
	output reg [13:0] count);
always @(posedge clk) begin
	if (preset)
		count <= preset_value;
	else if (enable)
		count <= count + 1;
end
	
endmodule