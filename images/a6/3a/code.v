module bidirectional_shift_register (
	input clk,
	input reset,
	input en,
	input ld,
	input dir,
	input [3:0] d,
	output reg [3:0] q);

	always @(posedge clk) begin
		if (reset) q <= 4'b0000;
		else if (ld) q <= d;
		else if (en) begin
			if (dir) q <= {1'b0, q[3:1]};
			else q <= {q[2:0], 1'b0};
		end
	end
endmodule