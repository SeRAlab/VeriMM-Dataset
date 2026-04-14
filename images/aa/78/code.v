module top_module(input clk, input load, input shift, input [11:0]dat, input reset,output lastbit);reg[11:0] pshift, nshift;


assign lastbit=pshift[0];


always@(posedge clk)
begin 
   if (clk)
   pshift<=nshift;
end


always@(pshift,load,shift,dat, reset)
	begin 
		
		nshift=pshift;
		if (reset)
			nshift = 11'b0;
		else if (load)
			
			nshift=dat;
		else if(shift)
			begin
				
				nshift = pshift >> 1;
				nshift[11] = 1'b1;
			end
	end
endmodule