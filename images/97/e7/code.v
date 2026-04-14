module top_module(
   
   zn,
   
   a, b, c
   );parameter DELAY = 1;
   input a,b,c;
   output zn;

   assign #DELAY zn= !(a & b & c);

endmodule