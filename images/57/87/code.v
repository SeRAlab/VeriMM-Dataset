module up_down_counter(
	input clk,
	input enable,
	input up,
	output reg [3:0] q);initial
	q = 4'b0000;
		
always @(posedge clk)
	if (enable) begin
		if (up)
			q <= q + 1;
		else
			q <= q - 1;
	end

endmodule