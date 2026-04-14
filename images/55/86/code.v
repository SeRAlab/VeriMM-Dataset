module binary_counter_with_enable (
	input clk,
	input enable,
	output [2:0] count);reg [2:0] count_reg = 3'b000;

	always @(posedge clk) begin
		if (enable)
			count_reg <= count_reg + 1;
	end
	
	assign count = count_reg;
	
endmodule