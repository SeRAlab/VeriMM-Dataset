module microwave_oven (
	input clk,
	input resetn,
	input start,
	output reg cooking);

	parameter IDLE=0, COOKING=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= IDLE;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			IDLE: next_state = start ? COOKING : IDLE;
			COOKING: next_state = start ? COOKING : IDLE;
			default: next_state = IDLE;
		endcase
	end

	always @(state) begin
		case (state)
			COOKING: cooking = 1;
			default: cooking = 0;
		endcase
	end
endmodule