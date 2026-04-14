module reg12 (
	input clk,
	input reset,
	input enable,
	input [11:0] d,
	output reg [11:0] q
);always @(posedge clk) begin
	if (reset)
		q <= 12'b000000000000;
	else if (enable)
		q <= d;
end

endmodule