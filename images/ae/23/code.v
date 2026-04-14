module binary_down_counter (
	input clk,
	output [5:0] q);reg [5:0] count_reg = 6'b111111;

	always @(posedge clk) begin
		count_reg <= count_reg - 1;
	end
	
	assign q = count_reg;
	
endmodule