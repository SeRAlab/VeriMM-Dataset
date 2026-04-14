module top_module (
	input clk,
	input up,
	input down,
	output reg [3:0] q);initial
		q = 0;
		
	always@(posedge clk) begin
		if (up)
			q <= q + 1;
		else if (down)
			q <= q - 1;
	end

endmodule