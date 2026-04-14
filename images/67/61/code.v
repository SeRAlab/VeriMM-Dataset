module conveyor_belt (
	input clk,
	input resetn,
	input start,
	input stop,
	output running);

	parameter STOPPED=0, RUNNING=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= STOPPED;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			STOPPED: next_state = start ? RUNNING : STOPPED;
			RUNNING: next_state = stop ? STOPPED : RUNNING;
			default: next_state = STOPPED;
		endcase
	end

	assign running = (state == RUNNING);
endmodule