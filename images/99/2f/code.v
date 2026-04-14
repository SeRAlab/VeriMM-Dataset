module top_module (
	input clk,
	input p,
	input q,
	input r,
	output reg s);initial
		s = 0;
		
	always@(posedge clk) begin
		s <= ~(p | q | r);
	end

endmodule