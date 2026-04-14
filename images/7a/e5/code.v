module top_module(
	input [7:0] A,
	input [7:0] B,
	input reset,
	input clk,               // Added clk as an input
	output reg [15:0] C
);always @(posedge clk) begin
		if (reset) begin
			C <= 16'b0;
		end else begin
			C <= A + B;
		end
	end

endmodule