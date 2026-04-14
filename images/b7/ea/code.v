module top_module(A, B, C, Z);input  A ;
input  B ;
input  C ;
output Z ;

   wire I0_out, I1_out;
   and (I0_out, A, B);
   and (I1_out, I0_out, C);
   not (Z, I1_out);

endmodule