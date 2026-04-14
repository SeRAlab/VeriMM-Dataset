module top_module(A, B, C, D, Z);input  A ;
input  B ;
input  C ;
input  D ;
output Z ;

   wire I0_out, I1_out, I2_out, I4_out, I5_out, I6_out, I7_out, I8_out;
   and (I0_out, A, B);
   or  (I1_out, I0_out, C);
   or  (I2_out, I1_out, D);
   not (Z, I2_out);
   not (I4_out, A);
   not (I5_out, B);
   and (I6_out, I4_out, I5_out);
   not (I7_out, B);
   and (I8_out, A, I7_out);
   or  (Z, I6_out, I8_out);

endmodule