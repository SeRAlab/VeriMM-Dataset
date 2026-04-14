module top_module(P,Q,S1,S0,Reset,TerminalCount, CLOCK) ;parameter	LENGTH = 4;
parameter EndCount = 9;
parameter BeginCount = 0;
parameter InitialCount = 0;
input		S1, S0, Reset, CLOCK;
input	[LENGTH-1:0]	P;
output 	reg [LENGTH-1:0]	Q;
output TerminalCount;	
reg	[LENGTH-1:0]	NextQ;

always @ (posedge CLOCK or posedge Reset)
	if(Reset==1)	Q <= InitialCount;
	else	Q<=NextQ;

assign TerminalCount = (S1==0)&(S0==1)&(Q==EndCount) | (S1==1)&(S0==0)&(Q==BeginCount);

always@(P or Q or S1 or S0)
	case ({S1,S0})
	0:	NextQ <= Q;	
	1:	begin if (Q==EndCount) begin NextQ<=BeginCount; end
		else begin NextQ <= Q+1'b1;	end
		end 
	2:	begin if (Q==BeginCount) begin NextQ<=EndCount; end
		else begin NextQ <= Q-1'b1;	end
		end 
	3:	NextQ <= P;				
	endcase
endmodule