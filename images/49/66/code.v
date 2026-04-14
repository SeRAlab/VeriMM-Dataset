module top_module(clk_vga, hs, vs,hc_visible,vc_visible);input clk_vga;                      
	output hs, vs; 
	output [9:0]hc_visible;
	output [9:0]vc_visible; 

	
	parameter hpixels = 10'd800;  
	parameter vlines  = 10'd500;  

	parameter hfp  = 10'd16;      
	parameter hsc  = 10'd64;      
	parameter hbp  = 10'd80;      
	
	parameter vfp  = 10'd3;       
	parameter vsc  = 10'd4;       
	parameter vbp  = 10'd13;      
	
	
	reg [9:0] hc, hc_next, vc, vc_next;             
	
	assign hc_visible = ((hc < (hpixels - hfp)) && (hc > (hsc + hbp)))?(hc -(hsc + hbp)):10'd0;
	assign vc_visible = ((vc < (vlines - vfp)) && (vc > (vsc + vbp)))?(vc - (vsc + vbp)):10'd0;
	
	
	

	always@(*)
		if(hc == hpixels)				
			hc_next = 10'd0;			
		else
			hc_next = hc + 10'd1;		

	
	
	always@(*)
		if(hc == 10'd0)
			if(vc == vlines)
				vc_next = 10'd0;
			else
				vc_next = vc + 10'd1;
		else
			vc_next = vc;
	
	always@(posedge clk_vga)
		{hc, vc} <= {hc_next, vc_next};
		
	assign hs = (hc < hsc) ? 1'b0 : 1'b1;   
	assign vs = (vc < vsc) ? 1'b0 : 1'b1;   
	
endmodule