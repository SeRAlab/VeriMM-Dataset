module c2n (a, b, q);
   input a;			
   input b;			
   output q;			
   wire m;			
   and U1 (m, b, q);
   or  U2 (q, m, a);
endmodule