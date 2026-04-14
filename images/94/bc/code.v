module top_module(
   
   zn,
   
   a, b, c, d
   );parameter DELAY = 1;
   input a,b,c,d;
   output zn;

   assign #DELAY zn= !(a & b & c & d);

endmodule