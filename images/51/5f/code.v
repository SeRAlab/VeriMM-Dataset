module top_module (
	input clk,
	input reset,
	output reg [11:0] count);always @(posedge clk or posedge reset) begin
	if (reset)
		count <= 12'b111111111111;
	else
		count <= count + 8;
end

endmodule