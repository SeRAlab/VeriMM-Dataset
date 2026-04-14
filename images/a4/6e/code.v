module up_down_counter(
	input clk,
	input reset_n,
	input enable,
	input dir,
	output reg [15:0] q);always @(posedge clk or negedge reset_n)
	if (!reset_n)
		q <= 16'b0;
	else if (enable) begin
		if (dir)
			q <= q + 1;
		else
			q <= q - 1;
	end

endmodule