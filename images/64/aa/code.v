module gray_counter5bit_tc (
	input clk,
	input rst,
	output reg [4:0] q,
	output tc);

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 5'b00000;
		else
			q <= {q[4], q[3], q[2], q[1], ~q[0]};
	end
	
	assign tc = (q == 5'b11111) ? 1 : 0;
	
endmodule