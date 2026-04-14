module down_preset_counter (
	input clk,
	input reset,
	input [6:0] preset,
	output reg [6:0] count);always @(posedge clk or posedge reset)
begin
	if (reset)
		count <= preset;
	else
		count <= count - 1;
end

endmodule