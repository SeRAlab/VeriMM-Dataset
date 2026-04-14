module counter4bit_ud_tc (
	input clk,
	input rst,
	input up_down,
	output reg [3:0] q,
	output tc);

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 4'b0000;
		else if (up_down)
			q <= q + 1;
		else
			q <= q - 1;
	end
	
	assign tc = (up_down ? (q == 4'b1111) : (q == 4'b0000)) ? 1 : 0;
	
endmodule