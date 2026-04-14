module top_module(SVSTOP,dummy,FCLK,EMEMRAMCLK);input SVSTOP;
   output dummy;
   input  FCLK;
   input  EMEMRAMCLK;
   
   assign dummy = SVSTOP;endmodule