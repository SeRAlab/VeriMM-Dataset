module up_down_counter (
	input clk,
	input up_down,
	output [3:0] q);reg [3:0] count_reg = 4'b0000;

	always @(posedge clk) begin
		if (up_down)
			count_reg <= count_reg + 1;
		else
			count_reg <= count_reg - 1;
	end
	
	assign q = count_reg;
	
endmodule