module top_module (
	input clk,
	input load,
	input [9:0] d,
	output reg [9:0] q);always @(posedge clk) begin
		if (load)
			q <= d;
		else
			q <= {q[8:0], 1'b0};
	end

endmodule