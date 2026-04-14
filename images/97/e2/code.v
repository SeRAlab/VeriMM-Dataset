module ring_counter10bit_tc (
	input clk,
	input rst,
	output reg [9:0] q,
	output tc);

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 10'b0000000001;
		else
			q <= {q[8:0], q[9]};
	end
	
	assign tc = q[9];
	
endmodule