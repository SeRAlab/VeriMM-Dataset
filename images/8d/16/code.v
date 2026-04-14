module top_module (
	input clk,
	input reset,
	input up_request,
	input down_request,
	output reg moving_up,
	output reg moving_down,
	output reg stationary);parameter STATIONARY=0, MOVING_UP=1, MOVING_DOWN=2;
	reg [1:0] state;
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= STATIONARY;
		end else begin
			case (state)
				STATIONARY: begin
					if (down_request) state <= MOVING_DOWN;
					else if (up_request) state <= MOVING_UP;
				end
				MOVING_UP: begin
					if (!up_request && down_request) state <= MOVING_DOWN;
					else if (!up_request) state <= STATIONARY;
				end
				MOVING_DOWN: begin
					if (!down_request && up_request) state <= MOVING_UP;
					else if (!down_request) state <= STATIONARY;
				end
			endcase
		end
	end
	
	always @(*) begin
		case (state)
			STATIONARY: begin moving_up = 0; moving_down = 0; stationary = 1; end
			MOVING_UP: begin moving_up = 1; moving_down = 0; stationary = 0; end
			MOVING_DOWN: begin moving_up = 0; moving_down = 1; stationary = 0; end
		endcase
	end
	
endmodule