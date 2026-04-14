module top_module( clk, reset, q );input clk, reset;
	output reg [3:0] q;
	reg [3:0] q_next;
	
	always @(posedge clk) begin
		if (reset == 1'b0)
			q_next <= 4'b0000;
		else
			q_next <= q + 1;
	end
	
	always @(posedge clk) begin
		if (reset == 1'b0)
			q <= 4'b0000;
		else
			q <= q_next;
	end
endmodule