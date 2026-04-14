module reg24(
    input clk,
    input load,
    input clr,
    input [23:0] data,
    output reg [23:0] q);always @(posedge clk)
	if (clr)
		q <= 24'b0;
	else if (load)
		q <= data;

endmodule