module washing_machine (
	input clk,
	input resetn,
	input start,
	output reg washing);

	parameter IDLE=0, WASHING=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= IDLE;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			IDLE: next_state = start ? WASHING : IDLE;
			WASHING: next_state = start ? WASHING : IDLE;
			default: next_state = IDLE;
		endcase
	end

	always @(state) begin
		case (state)
			WASHING: washing = 1;
			default: washing = 0;
		endcase
	end
endmodule