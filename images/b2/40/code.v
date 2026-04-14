module reg16 (
	input clk,
	input reset,
	input [15:0] d,
	output reg [15:0] q
);always @(posedge clk) begin
	if (reset)
		q <= 16'b0000000000000000;
	else
		q <= d;
end

endmodule