module top_module (
	input clk,
	input up,
	input down,
	input reset,
	output reg [2:0] count);always @(posedge clk or posedge reset)
begin
	if (reset)
		count <= 3'b000;
	else if (up & ~down)
		count <= count + 1;
	else if (~up & down)
		count <= count - 1;
end

endmodule