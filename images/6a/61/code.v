module top_module(Y, A, B, C, D, S0, S1);input A, B, C, D, S0, S1;
   output Y;

   assign Y = (S1 == 0 && S0 == 0) ? A :
              (S1 == 0 && S0 == 1) ? B :
              (S1 == 1 && S0 == 0) ? C :
                                     D ;

endmodule