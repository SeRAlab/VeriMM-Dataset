module top_module(
	input clk,
	input up,
	output [3:0] count);reg [3:0] count_reg = 4'b0000;

	always @(posedge clk) begin
		if (up)
			count_reg <= count_reg + 1;
		else
			count_reg <= count_reg - 1;
	end

	assign count = count_reg;

endmodule