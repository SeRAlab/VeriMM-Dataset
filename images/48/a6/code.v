module down_counter(
    input clk,
    input reset_n,
    output reg [3:0] q);always @(posedge clk)
	if (!reset_n)
		q <= 4'b1111;
	else
		q <= q - 1;

endmodule