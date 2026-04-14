module top_module(blink,resetCount, enable,up,start, stop, countDown,clk,resetButton,reset,cascade);output  resetCount, enable, up, blink; 
    input   cascade, start, stop, countDown, clk, resetButton, reset; 

    reg[1:0]     S, nS;
    parameter   STOPPED=2'b00, COUNTING=2'b01,BLINK=2'b11;

	
    always @(posedge clk)
	begin
	if(reset)
	   S<=STOPPED;
	  else
		S <= nS;

     end       
			
    always @(S, start, stop, resetButton)
        case(S)
            STOPPED:  nS = (start && !stop && !resetButton) ? COUNTING  : STOPPED;
            COUNTING: if(cascade) nS = BLINK; else if(stop && !start) nS=STOPPED; else nS=COUNTING;
            BLINK:    if(start && !stop) nS = COUNTING; else if (stop && !start) nS=STOPPED; else nS=BLINK;
            default:  nS = STOPPED;
        endcase

	assign up = (S==STOPPED) ? countDown : up;
	assign enable = (S==COUNTING);
    assign resetCount = (S==STOPPED) && resetButton;
    assign blink = (S==BLINK);
    
    endmodule