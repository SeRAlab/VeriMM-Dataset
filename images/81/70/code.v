module bcd_counter(
	input clk,
	input rst,
	output reg [3:0] q);
always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 4'b0000;
		else if (q == 4'b1001)
			q <= 4'b0000;
		else
			q <= q + 1;
	end
endmodule