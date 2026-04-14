module garage_door (
	input clk,
	input resetn,
	input button,
	output reg open);

	parameter CLOSED=0, OPEN=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= CLOSED;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			CLOSED: next_state = button ? OPEN : CLOSED;
			OPEN: next_state = button ? CLOSED : OPEN;
			default: next_state = CLOSED;
		endcase
	end

	always @(state) begin
		case (state)
			OPEN: open = 1;
			default: open = 0;
		endcase
	end
endmodule