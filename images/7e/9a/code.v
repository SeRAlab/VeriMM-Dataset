module traffic_light (
	input clk,
	input reset,
	output reg red,
	output reg yellow,
	output reg green);parameter RED=0, YELLOW=1, GREEN=2;
	reg [1:0] state;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= RED;
		end else begin
			case (state)
				RED: state <= GREEN;
				GREEN: state <= YELLOW;
				YELLOW: state <= RED;
			endcase
		end
	end

	always @(*) begin
		case (state)
			RED: begin red = 1; yellow = 0; green = 0; end
			GREEN: begin red = 0; yellow = 0; green = 1; end
			YELLOW: begin red = 0; yellow = 1; green = 0; end
		endcase
	end
	
endmodule