module bcd_counter8bit_tc (
	input clk,
	input rst,
	output reg [7:0] q,
	output tc);

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 8'b00000000;
		else if (q[3:0] == 4'b1001) begin
			if (q[7:4] == 4'b1001)
				q <= 8'b00000000;
			else
				q <= {q[7:4] + 1, 4'b0000};
		end else
			q <= q + 1;
	end
	
	assign tc = (q == 8'b10011001) ? 1 : 0;
	
endmodule