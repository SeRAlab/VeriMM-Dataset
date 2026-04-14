module top_module (
	input clk,
	input sreset,
	input bin,
	output gray);reg prev_bin;
always @(posedge clk) begin
	if (sreset)
		prev_bin <= 0;
	else
		prev_bin <= bin;
end

assign gray = bin ^ prev_bin;

endmodule