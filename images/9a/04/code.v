module fibonacci_lfsr(
	input clk,
	input en,
	output reg [4:0] q);

initial
	q = 5'b00001;

always @(posedge clk)
	if (en)
		q <= {q[3:0], q[4] ^ q[2]};
endmodule