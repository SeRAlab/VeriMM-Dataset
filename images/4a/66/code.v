module top_module(X, Z, RESET, CLOCK, CurrentState);input	X, RESET, CLOCK;
	output reg Z;


	
	output reg [1:0] CurrentState;
	reg [1:0] NextState;


	
	parameter	State0 = 0, State1 = 1, State2 = 2, State3 = 3;

	
	always @ (CurrentState)
		if(CurrentState==State0) Z<=1;
		else if (CurrentState==State3) Z<=0;
		else Z<=0;
	
	
	always @ (posedge CLOCK)
		if (RESET==1) CurrentState <= State0; else CurrentState <= NextState;	
	
	always@(CurrentState or X) 
		case (CurrentState)
		State0: if (X==0) NextState <= State1; else NextState <= State0;
		State1: if (X==0) NextState <= State1; else NextState <= State0;
		State3: if (X==0) NextState <= State1; else NextState <= State2;
		State2: NextState <= State2;
		endcase
endmodule