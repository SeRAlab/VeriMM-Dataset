module top_module (
	input clk,
	input reset,
	input [7:0] d,
	output reg [7:0] q);always @(posedge clk or posedge reset) begin
		if (reset)
			q <= d;
		else
			q <= {q[6:0], q[7]};
	end
	
endmodule