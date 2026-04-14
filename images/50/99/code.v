module pwm_generator(
	input clk,
	input rst_n,
	input [7:0] duty_cycle,
	output reg pwm_out
);

	reg [7:0] counter;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			counter <= 8'b0;
		else
			counter <= counter + 1;
	end

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n)
			pwm_out <= 1'b0;
		else
			pwm_out <= (counter < duty_cycle) ? 1'b1 : 1'b0;
	end

endmodule