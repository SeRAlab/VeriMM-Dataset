module mod6_counter (
	input clk,
	input reset,
	output reg [2:0] count);always @(posedge clk or posedge reset)
begin
	if (reset)
		count <= 3'b000;
	else if (count == 3'b101)
		count <= 3'b000;
	else
		count <= count + 1;
end

endmodule