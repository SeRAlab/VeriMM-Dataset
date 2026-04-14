module coffee_machine (
	input clk,
	input resetn,
	input brew,
	input stop,
	output reg brewing);

	parameter IDLE=0, BREWING=1;
	reg state, next_state;

	always @(posedge clk) begin
		if (~resetn) state <= IDLE;
		else state <= next_state;
	end

	always_comb begin
		case (state)
			IDLE: next_state = brew ? BREWING : IDLE;
			BREWING: next_state = stop ? IDLE : BREWING;
			default: next_state = IDLE;
		endcase
	end

	always @(state) begin
		case (state)
			BREWING: brewing = 1;
			default: brewing = 0;
		endcase
	end
endmodule