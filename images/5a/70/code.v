module up_down_counter (
	input clk,
	input reset,
	input direction,
	output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
	if (reset)
		count <= 4'b0000;
	else if (direction)
		count <= count + 1;
	else
		count <= count - 1;
end

endmodule