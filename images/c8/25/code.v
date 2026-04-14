module REG32 (
	input [31:0] in,
	input clk,
	input R,
	output reg [31:0] out
);

	always @(posedge clk) begin
		if (R == 1) begin
			out <= 0;
		end
		else begin
			out <= in;
		end
	end

endmodule