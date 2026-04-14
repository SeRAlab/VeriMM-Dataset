module top_module(
	input 	clk,	  			
	input	wr,					
	input 	reset, 				
	input 	icrs,				
	input	ta,					
	input	tb,				    
	input	alrm,	 			
	input 	flag, 				
	input 	ser,				
	input 	[7:0] data_in,		
	output 	[7:0] data_out,		
	output	irq					
);reg  [4:0] icr = 5'd0;			
reg  [4:0] icrmask = 5'd0;		


assign data_out[7:0] = icrs && !wr ? {irq,2'b00,icr[4:0]} : 8'b0000_0000;


always @(posedge clk)
	if (reset)
		icrmask[4:0] <= 5'b0_0000;
	else if (icrs && wr)
	begin
		if (data_in[7])
			icrmask[4:0] <= icrmask[4:0] | data_in[4:0];
		else
			icrmask[4:0] <= icrmask[4:0] & (~data_in[4:0]);
	end


always @(posedge clk)
	if (reset)
		icr[4:0] <= 5'b0_0000;
	else if (icrs && !wr)
	begin
		icr[0] <= ta;			
		icr[1] <= tb;			
		icr[2] <= alrm;   		
		icr[3] <= ser;	 		
		icr[4] <= flag;			
	end
	else
	begin
		icr[0] <= icr[0] | ta;		
		icr[1] <= icr[1] | tb;		
		icr[2] <= icr[2] | alrm;	
		icr[3] <= icr[3] | ser;		
		icr[4] <= icr[4] | flag;	
	end


assign irq 	= (icrmask[0] & icr[0]) 
			| (icrmask[1] & icr[1])
			| (icrmask[2] & icr[2])
			| (icrmask[3] & icr[3])
			| (icrmask[4] & icr[4]);

endmodule