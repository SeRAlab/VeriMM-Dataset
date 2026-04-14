module top_module(A, B, Y);input  A ;
input  B ;
output Y ;
wire I0_out;

   or  (I0_out, A, B);
   not (Y, I0_out);

endmodule