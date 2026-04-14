module reg16(
    input clk,
    input load,
    input [15:0] data,
    output reg [15:0] q);always @(posedge clk)
	if (load)
		q <= data;

endmodule