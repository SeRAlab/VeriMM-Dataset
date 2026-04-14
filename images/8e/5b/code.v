module johnson_counter(
	input clk,
	input reset,
	output reg [4:0] q);
always @(posedge clk) begin
	if (reset)
		q <= 0;
	else
		q <= {~q[0], q[4:1]};
end

endmodule