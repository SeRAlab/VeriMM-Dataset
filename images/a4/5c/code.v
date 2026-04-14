module top_module (
	input clk,
	input g,
	input h,
	output reg out);

	initial
		out = 0;

	always@(posedge clk) begin
		out <= g & h;
	end

endmodule