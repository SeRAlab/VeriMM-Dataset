module top_module( a, b, o);input  a;
   input  b;
   output reg o;

   always @(a or b)
     if (a)
       o <= b;

endmodule