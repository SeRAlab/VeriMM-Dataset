module top_module(
	input clk,
	input clr,
	input load,
	input [7:0] load_val,
	output reg [7:0] q);always @(posedge clk) begin
	if (clr)
		q <= 8'b00000000;
	else if (load)
		q <= load_val;
end
endmodule