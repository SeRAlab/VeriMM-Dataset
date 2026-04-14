module top_module (
	input clk,
	input reset,
	output reg [3:0] q);initial
		q = 0;
		
	always@(posedge clk or posedge reset) begin
		if (reset)
			q <= 0;
		else
			q <= {q[2:0], ~q[3]};
	end

endmodule