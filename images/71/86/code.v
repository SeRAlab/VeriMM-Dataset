module ring_counter(
    input clk,
    input reset,
    output reg [5:0] q);always @(posedge clk)
	if (reset)
		q <= 6'b000001;
	else
		q <= {q[4:0], q[5]};

endmodule