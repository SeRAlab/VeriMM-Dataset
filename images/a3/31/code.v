module smart_light (
	input clk,
	input resetn,
	input presence,
	output reg light_on);

	parameter OFF=0, ON=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= OFF;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			OFF: next_state = presence ? ON : OFF;
			ON: next_state = presence ? ON : OFF;
			default: next_state = OFF;
		endcase
	end

	always @(state) begin
		case (state)
			ON: light_on = 1;
			default: light_on = 0;
		endcase
	end
endmodule