module d_ff (
	input clk,
	input reset,
	input enable,
	input d,
	output reg q);always @(posedge clk) begin
		if (reset)
			q <= 1'b1;
		else if (enable)
			q <= d;
	end
	
endmodule