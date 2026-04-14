module top_module (
	input clk,
	input a,
	input b,
	output reg out);initial
		out = 0;
		
	always@(posedge clk) begin
		out <= ~(a ^ b);
	end

endmodule