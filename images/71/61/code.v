module counter4bit_en (
	input clk,
	input rst,
	input en,
	output reg [3:0] q);

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 4'b0000;
		else if (en)
			q <= q + 1;
	end
	
endmodule