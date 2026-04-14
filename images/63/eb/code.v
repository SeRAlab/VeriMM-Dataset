module top_module(
	input clk_50M,
	input rst,
	output clk_1Khz
);reg clk_out;
	integer clk_cnt = 1'b0;
	parameter radio = 0;
	always @(posedge clk_50M or posedge rst) begin
		if (rst) begin
			clk_cnt <= 1'b0;
			
		end
		else if (clk_cnt == 32'd25000) begin
			clk_cnt <= 0;
			clk_out <= ~ clk_out;
		end
		else 
			clk_cnt <= clk_cnt + 1'b1;
	end

	assign clk_1Khz = clk_out;

endmodule