module top_module (
	input clk,
	input u,
	input v,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= ~(u | v);
	end

endmodule