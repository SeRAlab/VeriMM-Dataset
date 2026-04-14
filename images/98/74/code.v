module elevator_system (
	input clk,
	input resetn,
	input request,
	output reg moving);

	parameter IDLE=0, MOVING=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= IDLE;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			IDLE: next_state = request ? MOVING : IDLE;
			MOVING: next_state = IDLE;
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