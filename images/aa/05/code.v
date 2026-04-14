module top_module(input colSelA,
   input colSelB,
   input colSelC,
   input datai,
   output datao
   );assign datao = colSelC & colSelB & colSelA & datai;

endmodule