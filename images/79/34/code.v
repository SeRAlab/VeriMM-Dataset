module alarm_system (
	input clk,
	input resetn,
	input trigger,
	output reg alarm);

	parameter IDLE=0, ALARM_ON=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= IDLE;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			IDLE: next_state = trigger ? ALARM_ON : IDLE;
			ALARM_ON: next_state = trigger ? ALARM_ON : IDLE;
			default: next_state = IDLE;
		endcase
	end

	always @(state) begin
		case (state)
			ALARM_ON: alarm = 1;
			default: alarm = 0;
		endcase
	end
endmodule