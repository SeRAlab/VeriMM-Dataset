module counter (
	input clk,
	input reset,
	input enable,
	input up_down, // 1 for up, 0 for down
	output [3:0] count
);reg [3:0] count_reg;

always @(posedge clk or posedge reset) begin
	if (reset)
		count_reg <= 4'b0000;
	else if (enable) begin
		if (up_down)
			count_reg <= count_reg + 1;
		else
			count_reg <= count_reg - 1;
	end
end

assign count = count_reg;

endmodule