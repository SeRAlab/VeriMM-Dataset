module top_module(
    input clk,
    input reset,
    input enable,
    input canLeft,
    input canRight,
    output reg [2:0] motion
    );localparam NO_MOTION = 0;
	 localparam LEFT = 1;
	 localparam RIGHT =2;
	 localparam DOWN = 3;
	 
	 

	 always @(posedge clk) begin
	   if (reset) motion <= RIGHT;
	   
	   
		else if(enable) begin
		
			case(motion) 
		
				NO_MOTION : if (canRight) motion <= RIGHT;
								
								
								else motion <= DOWN;
				
				LEFT : if (canLeft) motion <= LEFT;
						 else if (~canLeft) motion <= DOWN;
						 else motion <= NO_MOTION;
				
				RIGHT : 	if (canRight) motion <= RIGHT;
							else if (~canRight) motion <= DOWN;
							else motion <= NO_MOTION;
				
				DOWN : 	if (canLeft) motion <= LEFT;
							else if (canRight) motion <= RIGHT;
							else motion <= NO_MOTION;
				
				default : motion <= NO_MOTION;
		  
			endcase
		end
			
	 end


endmodule