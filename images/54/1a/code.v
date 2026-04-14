module counter2bit_en_tc (
	input clk,
	input rst,
	input en,
	output reg [1:0] q,
	output tc);

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 2'b00;
		else if (en)
			q <= q + 1;
	end
	
	assign tc = (q == 2'b11) ? 1 : 0;
	
endmodule