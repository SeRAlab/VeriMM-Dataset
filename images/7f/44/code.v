module gray_code_counter(
	input clk,
	input en,
	output reg [2:0] q);

initial
	q = 3'b000;

always @(posedge clk)
	if (en)
		q <= {q[2] ^ q[1], q[1] ^ q[0], q[0] ^ 1'b1};
endmodule