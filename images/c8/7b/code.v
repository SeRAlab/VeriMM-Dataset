module mux_2to1 (M, A, B, S);
   input A, B, S;
   output M;

   assign M = (S == 1) ? B : A;

endmodule