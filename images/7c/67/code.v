module top_module(
	input clk,
	input reset,
	output reg [31:0] q);always @(posedge clk) begin
		if (reset)
			q <= 32'hFFFFFFFF;
		else
			q <= {q[30:0], q[31] ^ q[28]};
	end
endmodule