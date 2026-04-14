module top_module( clk, reset, d, q );input clk;
	input reset;
	input [5:0] d;
	output [5:0] q;
	reg [5:0] q;

	always @(posedge clk or negedge reset) begin
		if (!reset) begin
			q <= 6'b0;
		end
		else begin
			q <= d;
		end
	end
endmodule