module sequence_detector (
	input clk,
	input reset,
	input data_in,
	output reg detected);

	parameter IDLE=3'b000, S1=3'b001, S11=3'b010, S110=3'b011, S1101=3'b100;
	reg [2:0] state, next_state;

	always @(posedge clk or posedge reset) begin
		if (reset) state <= IDLE;
		else state <= next_state;
	end

	always @(state or data_in) begin
		case (state)
			IDLE: next_state = data_in ? S1 : IDLE;
			S1: next_state = data_in ? S11 : IDLE;
			S11: next_state = data_in ? S11 : S110;
			S110: next_state = data_in ? S1101 : IDLE;
			S1101: next_state = data_in ? S1 : IDLE;
			default: next_state = IDLE;
		endcase
	end

	always @(state) begin
		detected = (state == S1101);
	end
endmodule