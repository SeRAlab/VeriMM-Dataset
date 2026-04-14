module top_module (
	input clk,
	input in,
	input reset,
	output reg fall);reg prev_in;
	
	always @(posedge clk) begin
		if (reset) begin
			prev_in <= 0;
			fall <= 0;
		end else begin
			fall <= prev_in && !in;
			prev_in <= in;
		end
	end
	
endmodule