module top_module(rd1, rd2, clk, regwrite, ra1, ra2, wa, wd) ;input        clk ;
   input        regwrite ;  
   input  [2:0] ra1 ;	    
   input  [2:0] ra2 ;	    
   input  [2:0] wa  ;  	    

   input  [7:0] wd  ;	    
   output [7:0]  rd1, rd2 ; 

   
   reg  [7:0] REGS [7:0];


   
   always @(posedge clk)
      if (regwrite) REGS[wa] <= wd;	

   
   assign rd1 = ra1 ? REGS[ra1] : 0;   
   assign rd2 = ra2 ? REGS[ra2] : 0;   
   				       

endmodule