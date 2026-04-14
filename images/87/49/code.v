module top_module (
	input clk,
	input in1,
	input in2,
	input in3,
	output reg out);initial
		out = 0;
		
	always@(posedge clk) begin
		out <= ~(in1 & in2 & in3);
	end

endmodule