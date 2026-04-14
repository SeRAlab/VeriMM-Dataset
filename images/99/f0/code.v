module top_module(
    input clk,
    input reset,
    input enable,
    input canLeft,
    input canRight,
    output reg[2:0] Motion
    );parameter NO_MOTION = 0 ;
	parameter LEFT = 1 ;
	parameter RIGHT = 2 ;
	parameter DOWN = 3 ;
	
	reg[1:0] etat;
	always @(posedge clk) begin
	  if (reset) etat <= NO_MOTION;
	  else
		   if (enable)
				case (etat)
					NO_MOTION: if (canRight) etat <= RIGHT;
					RIGHT:     if (~canRight) etat <= DOWN;
					DOWN:      if (canLeft) etat <= LEFT;
							     else if (canRight) etat <= RIGHT;
								  else etat <= NO_MOTION;
					LEFT:      if (~canLeft) etat <= DOWN;
					default:   etat <= NO_MOTION;
				endcase
	end
	
	always @(etat) begin
		case (etat)
			NO_MOTION: Motion = 3'b000;
			RIGHT:     Motion = 3'b100;
			DOWN:      Motion = 3'b010;
			LEFT:      Motion = 3'b001;
			default:   Motion = 3'b000;
		endcase
	end

					
						
endmodule