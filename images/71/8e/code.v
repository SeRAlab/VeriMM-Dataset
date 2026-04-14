module top_module(flap, flapStateEnabled, clk, resetLow);input flap;
	input clk;
	input resetLow;
	output reg flapStateEnabled; 
	
	reg [4:0] currentState;
	reg [4:0] nextState;
	
	localparam flapState = 2'd0,  flapStateWait = 2'd1;
					
	always @(*)
	begin
		case (currentState)
			flapState:			nextState = flapStateWait;
			flapStateWait:  nextState = flap ? flapStateWait : flapState;
			default: 	nextState = flapStateWait;
		endcase
	end
	
	always @(posedge clk)
   begin: state_FFs
		if(!resetLow)
			begin
				currentState <= flapStateWait;
			end
      else
           currentState <= nextState;
   end

	always @(*)
	begin
		case (currentState)
			flapState: flapStateEnabled = 1'b1;
			flapStateWait: flapStateEnabled = 1'b0;
			default: flapStateEnabled = 1'b0;
		endcase
	end

endmodule