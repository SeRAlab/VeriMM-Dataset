module top_module(
	input clk,
	input reset,
	output [7:0] count);reg [7:0] johnson;

always @(posedge clk or posedge reset)
	if (reset)
		johnson <= 8'b00000000;
	else
		johnson <= {johnson[6:0], ~johnson[7]};

assign count = johnson;

endmodule