module top_module(M, A, B, S);input A, B, S;
   output M;

   assign M = (S == 1) ? B : A;

endmodule