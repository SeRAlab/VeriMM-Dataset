module top_module(D0, D1, TX, CLK, Q0, Q1);input D0;
	input D1;
	input TX;
	input CLK;
	output Q0;
	output Q1;
	parameter TXCLK_POL = 0;
	parameter INIT = 0;

	reg Q0;
	reg Q1;
	reg D0_d;
	reg D1_d;

	always @(posedge CLK) begin
		if (TXCLK_POL == 0 && TX == 1) begin
			Q0 <= D0_d;
			Q1 <= D1_d;
		end else if (TXCLK_POL == 1 && TX == 0) begin
			Q0 <= D0_d;
			Q1 <= D1_d;
		end
	end

	always @(negedge CLK) begin
		if (TXCLK_POL == 0 && TX == 1) begin
			D0_d <= D0;
			D1_d <= D1;
		end else if (TXCLK_POL == 1 && TX == 0) begin
			D0_d <= D0;
			D1_d <= D1;
		end
	end

	initial begin
		if (INIT == 0) begin
			Q0 <= 0;
			Q1 <= 0;
			D0_d <= 0;
			D1_d <= 0;
		end else if (INIT == 1) begin
			Q0 <= 1;
			Q1 <= 1;
			D0_d <= 1;
			D1_d <= 1;
		end
	end

endmodule