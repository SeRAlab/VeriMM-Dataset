module top_module(
	output reg [15:0] Q, 
	output reg [15:0] R, 
	input  [15:0] N, 
	input  [15:0] D);reg [4:0] i;
	
	

	always @(*)		
		begin
			
			if(D != 0)
				begin 
					
					Q = 0;
					R = 0;
					
					for(i = 15; i > 0; i = i - 1)
						begin
						
							R = R << 1;
							R[0] = N[i];
							
							if(R >= D)  
								begin				
									R = R - D;
									Q[i] = 1;
								end
								
						end
						
						R = R << 1;	
						R[0] = N[i];
							
							if(R >= D)  
								begin				
									R = R - D;
									Q[0] = 1;
								end
				end				
		end
				

endmodule