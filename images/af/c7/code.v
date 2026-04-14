module top_module(
    input [3:0] D,        
    input CLK,            
    input CLR_n,          
    input LOAD_n,         
    input ENP,            
    input ENT,            
    output [3:0]Q,         
    output RCO            
);reg [3:0]auxQ;

	
	always @(posedge CLK)
	begin
		
		if (!CLR_n)
		begin
			
			auxQ <= 4'b0;
		end 
		
		if( (CLR_n) && (!LOAD_n) )
		begin
			
			auxQ <= D;
		end 
		
		if (CLR_n && LOAD_n && ENP && ENT)
		begin
			
			auxQ <= Q + 1;
		end
	end	
	
	
	assign RCO = ( Q[0] && Q[1] && Q[2] && Q[3] );	
	
assign Q = auxQ;
endmodule