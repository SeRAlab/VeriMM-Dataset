module heater_system (
	input clk,
	input resetn,
	input enable,
	output reg heating);

	parameter OFF=0, HEATING=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= OFF;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			OFF: next_state = enable ? HEATING : OFF;
			HEATING: next_state = OFF;
			default: next_state = OFF;
		endcase
	end

	always @(state) begin
		case (state)
			HEATING: heating = 1;
			default: heating = 0;
		endcase
	end
endmodule