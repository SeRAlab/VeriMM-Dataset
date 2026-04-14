module digital_lock (
	input clk,
	input resetn,
	input [3:0] code,
	output reg unlocked);

	parameter LOCKED=0, UNLOCKED=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= LOCKED;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			LOCKED: next_state = (code == 4'b1101) ? UNLOCKED : LOCKED;
			UNLOCKED: next_state = LOCKED;
			default: next_state = LOCKED;
		endcase
	end

	always @(state) begin
		case (state)
			UNLOCKED: unlocked = 1;
			default: unlocked = 0;
		endcase
	end
endmodule