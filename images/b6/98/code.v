module reg24 (
	input clk,
	input clear,
	input [23:0] d,
	output reg [23:0] q
);always @(posedge clk or posedge clear) begin
	if (clear)
		q <= 24'b000000000000000000000000;
	else
		q <= d;
end

endmodule