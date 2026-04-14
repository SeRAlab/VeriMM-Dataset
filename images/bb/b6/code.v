module register16bit(
	input [15:0] d,
	input clk,
	input ld,
	input clr,
	output reg [15:0] q);

	always @(posedge clk) begin
		if (clr)
			q <= 16'b0;
		else if (ld)
			q <= d;
	end

endmodule