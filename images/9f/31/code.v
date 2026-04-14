module top_module (
	input clk_in,
	input areset,
	output clk_out);reg state;
always @(posedge clk_in, posedge areset) begin
	if (areset)
		state <= 0;
	else
		state <= ~state;
end

assign clk_out = state;

endmodule