module shift_register(
	input clk,
	input en,
	output reg [7:0] q);

initial
	q = 8'b00000000;

always @(posedge clk)
	if (en)
		q <= q << 1;
endmodule