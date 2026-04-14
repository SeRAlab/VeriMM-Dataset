module updown_counter4bit (
	input clk,
	input rst,
	input up,
	output reg [3:0] q);

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 4'b0000;
		else if (up)
			q <= q + 1;
		else
			q <= q - 1;
	end
	
endmodule