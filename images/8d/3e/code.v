module top_module(inClk, globalReset, outClk);input inClk, globalReset;
	reg reset = 1;
	output reg outClk =1 ;
	reg [27:0] counter = 0;
	
	always @ (posedge inClk) begin
		if (globalReset == 1)
			begin
				reset   <= 1;
				counter <= 0;
				outClk  <= 1;
			end
		
		else if (reset == 1) 
		reset  <= 0;
		
		else if (counter == 4) 
			begin
				counter  <= 0;
				outClk   <= ~outClk;
			end 
		else 
			begin
				counter <= counter + 1;
			end
	end
endmodule