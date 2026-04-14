module up_down_counter (
	input clk,
	input resetn,
	input dir,
	output reg [9:0] q);

always @(posedge clk or negedge resetn) begin
	if (~resetn)
		q <= 10'b0000000000;
	else if (dir)
		q <= q + 1;
	else
		q <= q - 1;
end

endmodule