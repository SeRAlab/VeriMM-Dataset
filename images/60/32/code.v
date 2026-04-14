module top_module(
	
	input [31:0] desired_duty_cycle_1000,
	input [31:0] clk_period_1000,
	input clk,
	input reset,
	input LOCKED,

	
	output reg fail);always @(posedge clk or posedge reset) begin
		if (reset) begin
			fail <= 0;
		end else if (LOCKED) begin
			#(((clk_period_1000 / 1000.0) * (desired_duty_cycle_1000 / 1000.0)) - 0.1);
			if (clk != 1) begin
				fail <= 1;
			end
			#0.2;
			if (clk != 0) begin
				fail <= 1;
			end
		end else begin
			fail <= 0;
		end
	end
endmodule