module counter_with_carry (
	input clk,
	output [3:0] count,
	output co);reg [3:0] count_reg = 4'b0000;

	always @(posedge clk) begin
		count_reg <= count_reg + 1;
	end
	
	assign count = count_reg;
	assign co = (count_reg == 4'b1111);
	
endmodule