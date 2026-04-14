module top_module (
	input clk,
	input reset,
	output reg green_NS,
	output reg green_EW);parameter NS_GREEN=0, EW_GREEN=1;
	reg [1:0] state;
	reg [3:0] timer; 
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			state <= NS_GREEN;
			timer <= 0;
		end else begin
			case (state)
				NS_GREEN: begin
					if (timer == 9) begin
						state <= EW_GREEN;
						timer <= 0;
					end else begin
						timer <= timer + 1;
					end
				end
				EW_GREEN: begin
					if (timer == 9) begin
						state <= NS_GREEN;
						timer <= 0;
					end else begin
						timer <= timer + 1;
					end
				end
			endcase
		end
	end
	
	always @(*) begin
		case (state)
			NS_GREEN: begin green_NS = 1; green_EW = 0; end
			EW_GREEN: begin green_NS = 0; green_EW = 1; end
		endcase
	end
	
endmodule