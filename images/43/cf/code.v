module sync_johnson_counter(
	input clk,
	output reg [5:0] q);

initial
		q = 6'b000000;
		
always @(posedge clk)
	q <= {~q[0], q[5:1]};

endmodule