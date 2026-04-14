module elevator_control (
	input clk,
	input resetn,
	input call,
	output reg moving);

	parameter IDLE=0, MOVING=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= IDLE;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			IDLE: next_state = call ? MOVING : IDLE;
			MOVING: next_state = call ? MOVING : IDLE;
			default: next_state = IDLE;
		endcase
	end

	always @(state) begin
		case (state)
			MOVING: moving = 1;
			default: moving = 0;
		endcase
	end
endmodule