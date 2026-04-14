module top_module(
   
   Q,
   
   C, CE, D1, D2, R, S
   );parameter DDR_CLK_EDGE=0; 
   parameter INIT=0; 
   parameter SRTYPE=0;
   
   input  C;    
   input  CE;   
   input  D1;   
   input  D2;   
   input  R;    
   input  S;    
   output Q;    

   reg 	  Q1,Q2;
   reg 	  Q2_reg;
   
   

   
   
   always @ (posedge C or posedge R)
     if (R)
       Q1 <= 1'b0;
     else
       Q1 <= D1;

   always @ (posedge C or posedge R)
     if (R)
       Q2 <= 1'b0;
     else
       Q2 <= D2;
  
   always @ (negedge C or posedge R)
     if (R)
       Q2_reg <= 1'b0;
     else
       Q2_reg <= Q2;

       
   assign Q = C ? Q1 : Q2_reg;
      
endmodule