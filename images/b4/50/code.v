module odd_parity_generator(
	input clk,
	input reset_n,
	input [2:0] data,
	output reg parity);always @(posedge clk or negedge reset_n)
	if (!reset_n)
		parity <= 1'b0;
	else
		parity <= data[0] ^ data[1] ^ data[2] ^ 1'b1;

endmodule