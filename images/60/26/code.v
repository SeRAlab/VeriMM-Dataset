module top_module(input clk, but, output reg debounced);reg [9:0] debTimer;
	always @(posedge clk) begin
		if (debounced == but)
			debTimer <= 0;
		else if (debTimer != -10'b1)
			debTimer <= debTimer+1;
		else if (debTimer == -10'b1)
			debounced <= but;
	end
endmodule