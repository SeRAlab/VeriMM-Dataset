module johnson_counter6bit_tc (
	input clk,
	input rst,
	output reg [5:0] q,
	output tc);

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 6'b000000;
		else
			q <= {~q[0], q[5:1]};
	end
	
	assign tc = (q == 6'b111111) ? 1 : 0;
	
endmodule