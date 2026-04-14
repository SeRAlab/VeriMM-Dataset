module top_module(
	input					clk_50M,						
	input					rst_n,							
	input					rx_int,							
	output					pos_rx_int,						
	output					neg_rx_int,						
	output					doub_rx_int						
);reg					clk_r=1'b0;
reg		[21:0]		cnt;
always	@(posedge	clk_50M	or	negedge	rst_n)				
	if(!rst_n)
			cnt		<=		22'b0;
	else
		if(cnt	==	22'd4194303)
				cnt		<=		22'b0;
		else
				cnt		<=		cnt		+1'b1;
				

always	@(posedge	clk_50M	or	negedge	rst_n)
	if(!rst_n)
		clk_r		<=		1'b0;
	else
		if(cnt	==	22'd4194300)
			clk_r	<=		~clk_r;
		else
			clk_r	<=		clk_r;
			
assign		clk	=	clk_r	;								


reg		rx_int0,rx_int1,rx_int2;							
															
always	@(posedge	clk	or	negedge	rst_n)
	begin
		if(!rst_n)
			begin
				rx_int0		<=		1'b0;
				rx_int1		<=		1'b0;
				rx_int2		<=		1'b0;
			end             
		else                
			begin           
				rx_int0		<=		rx_int;					
				rx_int1		<=	    rx_int0;				
				rx_int2		<=	    rx_int1;				
			end
	end

assign		pos_rx_int	=	rx_int1		&	~rx_int2;		
assign		neg_rx_int	=	~rx_int1	&	rx_int2;		
assign		doub_rx_int	=	rx_int1		^	rx_int2;		

endmodule