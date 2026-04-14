module top_module(A, B, Z);input  A ;
input  B ;
output Z ;

   not (A_not, A);
   not (B_not, B);
   and (AB, A_not, B_not);
   not (Z, AB);

endmodule