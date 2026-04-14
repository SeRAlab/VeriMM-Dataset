module mod1000_counter(
    input clk,
    input reset_n,
    output reg [9:0] q);always @(posedge clk or negedge reset_n)
	if (!reset_n)
		q <= 10'b0;
	else if (q == 999)
		q <= 10'b0;
	else
		q <= q + 1;

endmodule