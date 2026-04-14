module door_lock (
	input clk,
	input resetn,
	input key,
	output reg open);

	parameter LOCKED=0, UNLOCKED=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= LOCKED;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			LOCKED: next_state = key ? UNLOCKED : LOCKED;
			UNLOCKED: next_state = LOCKED;
			default: next_state = LOCKED;
		endcase
	end

	always @(state) begin
		case (state)
			UNLOCKED: open = 1;
			default: open = 0;
		endcase
	end
endmodule