module top_module(input       a,
   `ifdef TEST
   input       c,
   output wire d,
   `endif
   output wire b
   );assign b = a;
   `ifdef TEST
   assign d = c;
   `endif

endmodule