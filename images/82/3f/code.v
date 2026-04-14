module johnson_counter(
	input clk,
	output reg [3:0] q);

initial
	q = 4'b0000;

always @(posedge clk)
	q <= {~q[0], q[3:1]};

endmodule