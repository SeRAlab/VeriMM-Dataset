module zero_detector (
	input clk,
	input [3:0] x,
	output reg all_zero);always @(posedge clk) begin
		all_zero <= ~|x;
	end

endmodule