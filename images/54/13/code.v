module top_module(
	input clk,
	output [7:0] out);reg [7:0] ring_counter;

	initial
		ring_counter = 8'b00000001;

	always @(posedge clk)
		ring_counter <= {ring_counter[6:0], ring_counter[7]};

	assign out = ring_counter;

endmodule