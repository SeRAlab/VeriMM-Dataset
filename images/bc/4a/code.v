module reg18 (
	input clk,
	input load,
	input reset,
	input [17:0] d,
	output reg [17:0] q
);always @(posedge clk) begin
	if (reset)
		q <= 18'b000000000000000000;
	else if (load)
		q <= d;
end

endmodule