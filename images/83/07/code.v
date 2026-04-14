module sync_up_counter_with_preset(
	input clk,
	input enable,
	input preset,
	output reg [7:0] q);

initial
		q = 8'b10101010;
		
always @(posedge clk or posedge preset)
	if (preset)
		q <= 8'b10101010;
	else if (enable)
		q <= q + 1;

endmodule