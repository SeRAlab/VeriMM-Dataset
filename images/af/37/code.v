module top_module(
   
   a, b
   );output logic a, b;

   always_comb b = ~a;
   always_comb a = b;

endmodule