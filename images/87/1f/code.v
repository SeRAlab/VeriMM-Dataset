module top_module (
	input clk,
	input reset,
	input shift_enable,
	output reg [7:0] q);always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 8'b00000000;
		else if (shift_enable)
			q <= q << 1;
	end
	
endmodule