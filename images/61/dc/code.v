module top_module (
	input clk,
	input d,
	input e,
	input f,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= ~(d | e | f);
	end

endmodule