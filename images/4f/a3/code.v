module johnson_counter(
	input clk,
	input enable,
	input reset,
	output reg [4:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 5'b00000;
	else if (enable)
		q <= {~q[0], q[4:1]};
end
endmodule