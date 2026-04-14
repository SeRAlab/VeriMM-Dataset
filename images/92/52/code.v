module top_module(
	input clk,
	input load,
	input shift_left,
	input shift_right,
	input [3:0] load_value,
	output reg [3:0] q);
always @(posedge clk) begin
	if (load)
		q <= load_value;
	else if (shift_left)
		q <= q << 1;
	else if (shift_right)
		q <= q >> 1;
end
	
endmodule