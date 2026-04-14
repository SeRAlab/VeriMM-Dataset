module counter_with_sync_reset (
	input clk,
	input enable,
	input reset,
	output [2:0] count);reg [2:0] count_reg = 3'b000;

	always @(posedge clk) begin
		if (reset)
			count_reg <= 3'b000;
		else if (enable)
			count_reg <= count_reg + 1;
	end
	
	assign count = count_reg;
	
endmodule