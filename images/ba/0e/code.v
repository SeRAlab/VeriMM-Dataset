module top_module (
	input clk,
	input d,
	input e,
	output reg q);initial
		q = 0;
		
	always@(posedge clk) begin
		q <= ~(d ^ e);
	end

endmodule