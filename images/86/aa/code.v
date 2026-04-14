module top_module(
						clk, 
						rst, 
						req, 
						gnt
);input				clk;
	input				rst;
	input	[ 1: 0]		req;		
	output				gnt; 		
	

	
	
	
	


	parameter	      	grant0 = 1'h0,
	                	grant1 = 1'h1;
	            

	
	
	
	

	reg 				state = 0, next_state = 0;

	
	
	
	

	assign	gnt = state;

	always@(posedge clk or posedge rst)
		if(rst)		state <= #1 grant0;
		else		state <= #1 next_state;

	
	
	
	
	
	
	

	always@(state or req ) begin
		next_state = state;	
		case(state)		
	 	   grant0:
			
			if(!req[0] )
			   begin
				if(req[1])	next_state = grant1;
				
			   end
	 	   grant1:
			
			if(!req[1] ) begin
			    
				if(req[0])	next_state = grant0;
			end
			
		endcase
	end

endmodule