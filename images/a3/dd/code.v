module water_pump_control (
	input clk,
	input resetn,
	input level,
	output reg pump);

	parameter OFF=0, ON=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= OFF;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			OFF: next_state = level ? ON : OFF;
			ON: next_state = level ? ON : OFF;
			default: next_state = OFF;
		endcase
	end

	always @(state) begin
		case (state)
			ON: pump = 1;
			default: pump = 0;
		endcase
	end
endmodule