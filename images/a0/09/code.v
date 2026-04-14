module top_module (
	input clk,
	input reset,
	output reg [2:0] count);always @(posedge clk or posedge reset) begin
	if (reset)
		count <= 3'b111;
	else
		count <= count - 3;
end

endmodule