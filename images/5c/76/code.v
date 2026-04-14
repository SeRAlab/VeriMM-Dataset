module garage_door (
	input clk,
	input resetn,
	input open,
	input close,
	output reg door_open);

	parameter CLOSED=0, OPEN=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= CLOSED;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			CLOSED: next_state = open ? OPEN : CLOSED;
			OPEN: next_state = close ? CLOSED : OPEN;
			default: next_state = CLOSED;
		endcase
	end

	always @(state) begin
		case (state)
			OPEN: door_open = 1;
			default: door_open = 0;
		endcase
	end
endmodule