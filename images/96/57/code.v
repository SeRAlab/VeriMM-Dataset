module top_module(
	input clk,
	input reset,
	input serial_in,
	output reg [7:0] q);always @(posedge clk) begin
		if (reset)
			q <= 8'b0;
		else
			q <= {q[6:0], serial_in};
	end
endmodule