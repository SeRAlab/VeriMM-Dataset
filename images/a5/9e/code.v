module top_module (
	input clk,
	input u,
	input v,
	input w,
	output reg t);initial
		t = 0;
		
	always@(posedge clk) begin
		t <= u ^ v ^ w;
	end

endmodule