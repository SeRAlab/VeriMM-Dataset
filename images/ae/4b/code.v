module top_module(
	input clk,
	input load,
	input shift_left,
	input shift_right,
	input rst_n,
	input [7:0] load_value,
	output reg [7:0] q);
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		q <= 8'b0;
	else if (load)
		q <= load_value;
	else if (shift_left)
		q <= q << 1;
	else if (shift_right)
		q <= q >> 1;
end
	
endmodule