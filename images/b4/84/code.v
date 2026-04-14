module top_module (
	input clk,
	input reset_n,
	input en,
	output reg [9:0] q);

always @(posedge clk) begin
	if (!reset_n)
		q <= 10'b0000000000;
	else if (en)
		q <= q + 1;
	end
	
endmodule