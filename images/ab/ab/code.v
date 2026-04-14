module security_alarm (
	input clk,
	input resetn,
	input trigger,
	output reg alarm);

	parameter OFF=0, ON=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= OFF;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			OFF: next_state = trigger ? ON : OFF;
			ON: next_state = OFF;
			default: next_state = OFF;
		endcase
	end

	always @(state) begin
		case (state)
			ON: alarm = 1;
			default: alarm = 0;
		endcase
	end
endmodule