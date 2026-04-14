module top_module (
	input clk,
	input reset,
	input en,
	output reg [8:0] q);

always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 9'b000000000;
	else if (en)
		q <= q + 1;
	end
	
endmodule