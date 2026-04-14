module heating_system (
	input clk,
	input resetn,
	input too_cold,
	output reg heating);

	parameter OFF=0, ON=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= OFF;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			OFF: next_state = too_cold ? ON : OFF;
			ON: next_state = OFF;
			default: next_state = OFF;
		endcase
	end

	always @(state) begin
		case (state)
			ON: heating = 1;
			default: heating = 0;
		endcase
	end
endmodule