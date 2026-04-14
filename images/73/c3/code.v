module reg32 (
	input clk,
	input load,
	input [31:0] d,
	output reg [31:0] q
);always @(posedge clk) begin
	if (load)
		q <= d;
end

endmodule