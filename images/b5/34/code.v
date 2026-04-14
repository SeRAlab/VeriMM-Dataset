module top_module(clock, start, state, done);input    		clock; 
	input    [8:0] start; 
	input    [1:0] state; 
	output reg     done;  
		
	reg      [8:0] count;    
	
	
	
	
	
	
	
	always @ (posedge clock)
	begin
		if(state == 1)
		begin
			count = start;
		end
		
		if(state != 2)
		begin
			done = 0;
		end
	
	
		if(state == 2)
		begin
			if(count == 0)
			begin
				done = 1;
			end
			
			else
			begin
				count = count - 1;
			end
		end
	end
	
	
endmodule