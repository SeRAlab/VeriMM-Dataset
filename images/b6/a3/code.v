module top_module(
	input clk,
	output [2:0] count);reg [2:0] ring_counter;

always @(posedge clk)
	if (ring_counter == 3'b000)
		ring_counter <= 3'b001;
	else
		ring_counter <= {ring_counter[1:0], ring_counter[2]};

assign count = ring_counter;

endmodule