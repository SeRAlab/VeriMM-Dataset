module fasm_tpsram_rbw (
   dat_o, xdat_o,
   dat_i, adr_i, wre_i, stb_i, rst_i, clk_i, xdat_i, xadr_i, xwre_i,
   xstb_i, xrst_i, xclk_i
   );
   parameter AW = 8;  
   parameter DW = 32; 
   output [DW-1:0] dat_o; 
   input [DW-1:0]  dat_i; 
   input [AW-1:0]  adr_i; 
   input 	   wre_i; 
   input 	   stb_i; 
   input 	   rst_i,
		   clk_i;
   output [DW-1:0] xdat_o; 
   input [DW-1:0]  xdat_i; 
   input [AW-1:0]  xadr_i; 
   input 	   xwre_i; 
   input 	   xstb_i; 
   input 	   xrst_i,
		   xclk_i;
   reg [AW-1:0]    rA, rX;   
   reg [DW-1:0]    bram [(1<<AW)-1:0]; 
   always @(posedge xclk_i)
     if (xstb_i)
       begin
	  rX <= #1 bram[xadr_i];	  
       end
   always @(posedge clk_i)
     if (stb_i)
       begin	  
	  rA <= #1 bram[adr_i];	  
	  if (wre_i) 
	    bram[adr_i] <= #1 dat_i;	  
       end
   assign 	   xdat_o = rX; 
   assign 	   dat_o = rA; 
   integer i;
   initial begin
      for (i=0; i<(1<<AW); i=i+1) begin
	 bram[i] <= $random;	 
      end
   end   
endmodule