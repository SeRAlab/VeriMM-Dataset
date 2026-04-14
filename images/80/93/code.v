module top_module(GT, LT, A, B);output GT;
   output LT;

   input  [11:0] A;
   input  [11:0] B;


   assign GT = A > B  ;
   assign LT = A < B  ;    


endmodule