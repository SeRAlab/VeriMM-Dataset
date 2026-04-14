module top_module(
	clk,
	clk_ena,
	dataa,
	result);input	  clk;
	input	  clk_ena;
	input	[17:0]  dataa;
	output	[17:0]  result;

	reg     [17:0]  result;

	always @(posedge clk) begin
		if(clk_ena) begin
			result <= dataa;
		end
	end

endmodule