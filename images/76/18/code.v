module shift_register(
	input clk,
	input ld,
	input shift,
	input [7:0] d,
	output reg [7:0] q);

	always @(posedge clk) begin
		if (ld)
			q <= d;
		else if (shift)
			q <= {q[6:0], 1'b0};
	end
	
endmodule