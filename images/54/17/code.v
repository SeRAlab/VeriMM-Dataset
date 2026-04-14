module top_module(
	input clk,
	input load,
	input shift_left,
	input clear,
	input [19:0] load_value,
	output reg [19:0] q);
always @(posedge clk) begin
	if (clear)
		q <= 0;
	else if (load)
		q <= load_value;
	else if (shift_left)
		q <= q << 1;
end
	
endmodule