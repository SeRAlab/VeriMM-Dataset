module top_module(CLK_IN, PREEDGE,  CLK_OUT);input     CLK_IN;            
   output    PREEDGE;           
   output    CLK_OUT;           

   wire      CLK_OUT;
   wire      PREEDGE;
   
   assign    CLK_OUT = ! CLK_IN ;
   assign    PREEDGE = 1 ;
   
endmodule