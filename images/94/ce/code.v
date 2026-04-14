module edge_detector(
	input clk,
	input reset_n,
	input in,
	output reg pulse);reg in_d;

always @(posedge clk or negedge reset_n) begin
	if (!reset_n) begin
		in_d <= 0;
		pulse <= 0;
	end else begin
		pulse <= in & ~in_d;
		in_d <= in;
	end
end

endmodule