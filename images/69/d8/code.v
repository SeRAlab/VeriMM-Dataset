module top_module(
	input clk,
	input reset,
	output reg [7:0] q);always @(posedge clk) begin
		if (reset)
			q <= 8'b11001011;
		else
			q <= {q[6:0], q[7] ^ q[5]};
	end
endmodule