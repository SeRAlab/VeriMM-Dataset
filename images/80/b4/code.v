module up_down_counter(
	input clk,
	input reset_n,
	input up,
	input down,
	output reg [7:0] count);always @(posedge clk or negedge reset_n) begin
	if (!reset_n)
		count <= 8'b0;
	else if (up)
		count <= count + 1;
	else if (down)
		count <= count - 1;
end

endmodule