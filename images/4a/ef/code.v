module door_lock (
	input clk,
	input resetn,
	input unlock,
	output reg locked);

	parameter LOCKED=0, UNLOCKED=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= LOCKED;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			LOCKED: next_state = unlock ? UNLOCKED : LOCKED;
			UNLOCKED: next_state = LOCKED;
			default: next_state = LOCKED;
		endcase
	end

	always @(state) begin
		case (state)
			LOCKED: locked = 1;
			UNLOCKED: locked = 0;
			default: locked = 1;
		endcase
	end
endmodule