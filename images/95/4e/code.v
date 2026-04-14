module top_module( clk, reset, d, q );input clk;
	input reset;
	input [47:0] d;
	output [47:0] q;
	reg [47:0] q;

	always @(posedge clk or negedge reset) begin
		if (reset == 0) begin
			q <= 48'b0;
		end
		else begin
			q <= d;
		end
	end
endmodule