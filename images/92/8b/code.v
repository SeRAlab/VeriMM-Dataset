module up_down_counter(
	input clk,
	input up,
	input down,
	output reg [2:0] q);
always @(posedge clk) begin
		if (up)
			q <= q + 1;
		else if (down)
			q <= q - 1;
	end
endmodule