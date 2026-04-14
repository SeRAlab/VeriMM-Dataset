module top_module(
	input clk,
	input reset,
	input [255:0] rx_a,
	input [255:0] rx_b,

	output reg tx_done,
	output reg [511:0] tx_r
);reg [3:0] k;
	reg [2:0] i, j;
	reg [67:0] accum;

	wire [31:0] a = rx_a >> ({i, 5'd0});
	wire [31:0] b = rx_b >> ({j, 5'd0});
	wire [63:0] mult_result = a * b;
	wire [67:0] new_accum = accum + mult_result;


	always @ (posedge clk)
	begin
		accum <= new_accum;

		if (i == 7 || i == k)
		begin
			k <= k + 1;
			if (k < 7)
			begin
				i <= 0;
				j <= k + 1;
			end
			else
			begin
				i <= k - 6;
				j <= 7;
			end

			accum <= new_accum >> 32;

			if (!tx_done)
				tx_r <= tx_r | (new_accum[31:0] << ({k, 5'd0}));

			if (k == 14 && !tx_done)
			begin
				tx_done <= 1'b1;
				tx_r[511:480] <= new_accum[63:32];
			end
		end
		else
		begin
			i <= i + 1;
			j <= j - 1;
		end


		if (reset)
		begin
			k <= 4'd0;
			i <= 3'd0;
			j <= 3'd0;
			accum <= 68'd0;
			tx_r <= 512'd0;
			tx_done <= 1'b0;
		end
	end

endmodule