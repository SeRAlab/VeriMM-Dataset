module top_module(
	input clk,
	input reset,
	output reg [6:0] q);always @(posedge clk or negedge reset) begin
		if (!reset)
			q <= 7'b0000001;
		else
			q <= {q[5:0], q[6] ^ q[5]};
	end
endmodule