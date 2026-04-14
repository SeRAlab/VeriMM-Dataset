module top_module(
   input CE,
   input I,
   (* clkbuf_driver *)
   output O
);parameter CE_POLARITY = 1'b1;

   wire ce;
   assign ce = CE_POLARITY ? CE : ~CE;
   
   assign O = I & ce;
   
endmodule