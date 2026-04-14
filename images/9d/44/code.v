module pedestrian_crossing (
	input clk,
	input resetn,
	input pedestrian,
	output reg walk);

	parameter DONT_WALK=0, WALK=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= DONT_WALK;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			DONT_WALK: next_state = pedestrian ? WALK : DONT_WALK;
			WALK: next_state = DONT_WALK;
			default: next_state = DONT_WALK;
		endcase
	end

	always @(state) begin
		case (state)
			WALK: walk = 1;
			default: walk = 0;
		endcase
	end
endmodule