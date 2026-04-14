module shift_register (
	input clk,
	input reset,
	output reg [7:0] data);

always @(posedge clk or posedge reset)
	if (reset)
		data <= 8'b00000000;
	else
		data <= data >> 1;

endmodule