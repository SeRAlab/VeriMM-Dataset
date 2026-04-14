module top_module(
	input clk,
	input load,
	input [7:0] parallel_in,
	output reg [7:0] shift_reg);

always @(posedge clk) begin
	if (load)
		shift_reg <= parallel_in;
	else
		shift_reg <= {shift_reg[6:0], 1'b0};
end
endmodule