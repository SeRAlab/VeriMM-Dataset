module top_module( A, B, GIN, SUM );input  A;
   input  B;
   input  GIN;
   output SUM;
   assign SUM = ( ~ (A ^ B)) ^ GIN;
endmodule