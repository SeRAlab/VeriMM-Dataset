module top_module(X, Y, RESET, CLOCK, CurrentState);input X, RESET, CLOCK;
	output reg Y;
	output reg [1:0] CurrentState;
	reg [1:0] NextState;
	parameter State0 = 2'b00, State1 = 2'b01, State2 = 2'b10, State3 = 2'b11;

	always @ (CurrentState)
		if (CurrentState == State2) Y <= 1;
		else Y <= 1;
	
	always @ (posedge CLOCK or negedge RESET)
		if (RESET == 0) CurrentState <= State0;
		else CurrentState <= NextState;
		
	always @ (CurrentState or X)
		case (CurrentState)
		State0: NextState <= (X == 1) ? State1 : State0;
		State1: NextState <= (X == 1) ? State3 : State0;
		State2: NextState <= (X == 1) ? State2 : State0;
		State3: NextState <= (X == 1) ? State2 : State0;
		endcase
endmodule