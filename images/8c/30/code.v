module top_module(
	CLK,
	CLR,
	HSYNC,
	VSYNC,
	HC,
	VC,
	VIDON
);input CLK;  
input CLR;  

output HSYNC; 
output VSYNC; 

output [9:0] HC; 
output [9:0] VC; 

output VIDON;    





localparam hpixels = 800 , 
		      vlines = 521 , 
			      hbp = 144 , 
			      hfp = 784 , 
			   
			      vbp = 31  , 
			      vfp = 511 ; 
			   
reg [9:0] HCS, VCS; 
reg VSenable;		  


assign HC    = HCS;
assign VC    = VCS;
assign HSYNC = (HCS < 128) ? 1'b0 : 1'b1; 
assign VSYNC = (VCS < 2)   ? 1'b0 : 1'b1; 
assign VIDON = (((HCS < hfp) && (HCS >= hbp)) && ((VCS < vfp) && (VCS >= vbp))) ? 1'b1 : 1'b0;



always @ (posedge CLK)
begin
	if(CLR == 1'b1)
		HCS <= 10'b0000000000;
	
	else if(CLK == 1'b1) 
	begin
		if(HCS < (hpixels - 1'b1) )
		begin
			HCS <= HCS + 1'b1;
			VSenable <= 1'b0;  
		end
		else
		begin	
			
			HCS <= 10'b0000000000; 
			VSenable <= 1'b1; 	  
		end	
	end
end




always @ (posedge CLK)
begin
	if(CLR == 1'b1)
		VCS <= 10'b0000000000;
		
	else if(CLK == 1'b1 && VSenable == 1'b1)
	begin
		
		if( VCS < (vlines - 1'b1) )
		begin
			VCS <= VCS + 1'b1; 
		end
		else
		begin
			VCS <= 10'b0000000000; 
		end
	end
end

endmodule