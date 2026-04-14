module top_module(
	input			clk,
	input			reset_n,
	input	[31:0]	cmd_reg1,
	input	[31:0]	cmd_reg2,
	output			mclk,
	output			bclk,
	input			lrclk_clear,
	output			lrclk1,
	output			lrclk2
);wire [7:0]		mclk_divisor = cmd_reg1[31:24]; // divide by (n + 1)*2
	wire [7:0]		bclk_divisor = cmd_reg1[23:16]; // divide by (n + 1)*2
	wire [7:0]		lrclk1_divisor = cmd_reg2[15:8]; // divide by (n + 1)*2*16
	wire [7:0]		lrclk2_divisor = cmd_reg2[7:0]; // divide by (n + 1)*2*16

	reg [7:0]		mclk_counter = 0;
	reg 			mclk_tick = 0;
	assign			mclk = mclk_tick;

	reg [7:0]		bclk_counter = 0;
	reg 			bclk_tick = 0;
	assign			bclk = bclk_tick;

	reg [7:0]		lrclk1_counter = 0;
	reg 			lrclk1_tick = 0;
	assign			lrclk1 = lrclk1_tick;

	reg [7:0]		lrclk2_counter = 0;
	reg 			lrclk2_tick = 0;
	assign			lrclk2 = lrclk2_tick;

	always @(posedge clk or negedge reset_n) begin
		if (~reset_n) begin
			mclk_counter <= 0;
			mclk_tick <= 0;
			bclk_counter <= 0;
			bclk_tick <= 0;
			lrclk1_counter <= 0;
			lrclk1_tick <= 0;
			lrclk2_counter <= 0;
			lrclk2_tick <= 0;
		end else begin
			mclk_counter <= mclk_counter + 1;
			if (mclk_counter >= mclk_divisor) begin
				mclk_counter <= 0;
				mclk_tick <= ~mclk_tick;
			end

			bclk_counter <= bclk_counter + 1;
			if (bclk_counter >= bclk_divisor) begin
				bclk_counter <= 0;
				bclk_tick <= ~bclk_tick;
			end

			if (~lrclk_clear) begin
				lrclk1_counter <= 0;
				lrclk1_tick <= 0;
				lrclk2_counter <= 0;
				lrclk2_tick <= 0;
			end else begin
				lrclk1_counter <= lrclk1_counter + 1;
				if (lrclk1_counter >= lrclk1_divisor) begin
					lrclk1_counter <= 0;
					lrclk1_tick <= ~lrclk1_tick;
				end

				lrclk2_counter <= lrclk2_counter + 1;
				if (lrclk2_counter >= lrclk2_divisor) begin
					lrclk2_counter <= 0;
					lrclk2_tick <= ~lrclk2_tick;
				end
			end
		end
	end

endmodule