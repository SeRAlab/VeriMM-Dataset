module top_module (
	input clk,
	input rst,
	input d,
	input e,
	input f,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		if (rst)
			out <= 0;
		else
			out <= d | e | f;
	end

endmodule