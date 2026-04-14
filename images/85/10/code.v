module ring_counter(
	input clk,
	input rst,
	output reg [4:0] q);

initial
	q = 5'b00001;

always @(posedge clk or posedge rst)
	if (rst)
		q <= 5'b00001;
	else
		q <= {q[3:0], q[4]};
endmodule