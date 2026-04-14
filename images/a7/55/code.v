module top_module (
	input clk,
	input areset,
	input a,
	input b,
	input c,
	output z);always @(posedge clk, posedge areset) begin
	if (areset)
		z <= 0;
	else
		z <= (a & b) | (a & c) | (b & c);
end

endmodule