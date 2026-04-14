module top_module(
  
  input 	   clk,     
  input        clk_16,  
  input		   clk_16_en,
  input        scanlines,
  
  
  input 	   hs_in,
  input 	   vs_in,
  input  	r_in,
  input  	g_in,
  input  	b_in,

  
  output reg      hs_out,
  output reg 	   vs_out,
  output reg [1:0] r_out,
  output reg [1:0] g_out,
  output reg [1:0] b_out,

  output 	   is15k
);reg [2:0]  sd_out;



reg scanline;

always @(posedge clk) begin
   hs_out <= hs_sd;
   vs_out <= vs_in;

   
   if(vs_out != vs_in)
     scanline <= 1'b0;
   
    
    if(hs_out && !hs_sd)
         scanline <= !scanline;

    
	 if(!scanlines || !scanline) begin
		r_out <= { sd_out[2], sd_out[2] };
		g_out <= { sd_out[1], sd_out[1] };
		b_out <= { sd_out[0], sd_out[0] };
	end else begin
		r_out <= { 1'b0, sd_out[2] };
		g_out <= { 1'b0, sd_out[1] };
		b_out <= { 1'b0, sd_out[0] };
	end
end
   

   





reg [2:0] sd_buffer [2047:0];


reg vsD;
reg line_toggle;
always @(negedge clk_16) begin

	if (clk_16_en) begin 
	
   vsD <= vs_in;

   if(vsD != vs_in) 
     line_toggle <= 1'b0;

   
   if(hsD && !hs_in) 
     line_toggle <= !line_toggle;
	 
	end
end
   
always @(negedge clk_16) begin 

	if (clk_16_en) begin 
	
		sd_buffer[{line_toggle, hcnt}] <= { r_in, g_in, b_in };
	
	end
	
 end
   





assign is15k = hs_max > (16000000/20000);


reg [9:0] hs_max;
reg [9:0] hs_rise;
reg [9:0] hcnt;
reg hsD;
   
always @(negedge clk_16) begin

   if (clk_16_en) begin 
   
	   hsD <= hs_in;

	   
	   if(hsD && !hs_in) begin
		  hs_max <= hcnt;
		  hcnt <= 10'd0;
	   end else
		 hcnt <= hcnt + 10'd1;

	   
	   if(!hsD && hs_in)
		 hs_rise <= hcnt;
	 
	end
end
   




reg [9:0] sd_hcnt;
reg hs_sd;


always @(posedge clk) begin

   
   sd_hcnt <= sd_hcnt + 10'd1;
   if(hsD && !hs_in)     sd_hcnt <= hs_max;
   if(sd_hcnt == hs_max) sd_hcnt <= 10'd0;

   
   if(sd_hcnt == hs_max)  hs_sd <= 1'b0;
   if(sd_hcnt == hs_rise) hs_sd <= 1'b1;

   
   sd_out <= sd_buffer[{~line_toggle, sd_hcnt}];
end
   
endmodule