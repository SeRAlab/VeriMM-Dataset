module top_module (
	input clk,
	input resetn,
	input load,
	input [11:0] d,
	output reg [11:0] q);always @(posedge clk) begin
		if (~resetn)
			q <= 12'b000000000000;
		else if (load)
			q <= d;
		else
			q <= {q[10:0], 1'b0};
	end

endmodule