module simple_fsm (
	input clk,
	input reset,
	input signal,
	output reg [1:0] state);parameter IDLE = 2'b00, LOAD = 2'b01, EXECUTE = 2'b10;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		state <= IDLE;
	end else begin
		case (state)
			IDLE: if (signal) state <= LOAD;
			LOAD: if (signal) state <= EXECUTE;
			EXECUTE: if (!signal) state <= IDLE;
			default: state <= IDLE;
		endcase
	end
end

endmodule