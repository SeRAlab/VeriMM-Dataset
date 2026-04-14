module top_module (
	input clk,
	input p,
	input q,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= p ^ q;
	end

endmodule