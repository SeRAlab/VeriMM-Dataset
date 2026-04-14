module top_module(
   
   O, OB,
   
   I
   );parameter DIFF_TERM=0;
   parameter IOSTANDARD=0;
   parameter SLEW=0;
   
   input I;
   output O;
   output OB;

   assign O  = I;
   assign OB = ~I;
   
   
endmodule