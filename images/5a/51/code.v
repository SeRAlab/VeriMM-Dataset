module updown_counter (
	input clk,
	input reset,
	input dir,
	output reg [2:0] q
);always @(posedge clk) begin
	if (reset)
		q <= 3'b000;
	else if (dir)
		q <= q + 1;
	else
		q <= q - 1;
end

endmodule