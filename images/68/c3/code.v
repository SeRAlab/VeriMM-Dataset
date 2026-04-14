module top_module(
	input clk,
	input reset,
	input sig,
	output reg pulse);reg sig_d;
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			sig_d <= 0;
			pulse <= 0;
		end else begin
			pulse <= sig & ~sig_d;
			sig_d <= sig;
		end
	end
	
endmodule