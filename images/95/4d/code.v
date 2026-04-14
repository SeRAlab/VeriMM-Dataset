module top_module (
	input clk,
	input t,
	output reg q);initial
		q = 0;
		
	always@(posedge clk) begin
		if (t)
			q <= ~q;
	end

endmodule