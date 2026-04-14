module counter_with_preset (
	input clk,
	input reset,
	input preset,
	input [7:0] preset_data,
	output reg [7:0] count);

	always @(posedge clk) begin
		if (reset)
			count <= 8'b00000000;
		else if (preset)
			count <= preset_data;
		else
			count <= count + 1;
	end
	
endmodule