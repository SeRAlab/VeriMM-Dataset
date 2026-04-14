module top_module (
  input clk,
  input reset,
  input in,
  output reg state);parameter IDLE = 1'b0, ACTIVE = 1'b1;
always @(posedge clk or posedge reset) begin
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE: if (in) state <= ACTIVE;
				ACTIVE: state <= ACTIVE;
			endcase
	end
endmodule