module top_module (
	input clk,
	input in,
	input reset,
	output reg rise);reg prev_in;
	
	always @(posedge clk) begin
		if (reset) begin
			prev_in <= 0;
			rise <= 0;
		end else begin
			rise <= !prev_in && in;
			prev_in <= in;
		end
	end
	
endmodule