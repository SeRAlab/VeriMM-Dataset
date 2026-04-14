module top_module(
	input clk,
	input reset,
	input [255:0] rx_a,
	input [255:0] rx_b,
	input [255:0] rx_p,
	output reg tx_done = 1'b0,
	output reg [255:0] tx_a = 256'd0
);reg carry;

	always @ (posedge clk)
	begin
		if (!tx_done)
		begin
			if (carry)
				tx_a <= tx_a + rx_p;
			tx_done <= 1'b1;
		end

		if (reset)
		begin
			{carry, tx_a} <= rx_a - rx_b;
			tx_done <= 1'b0;
		end
	end

endmodule