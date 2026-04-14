module c2p (a, b, q);
   input a;			
   input b;			
   output q;			
   wire m;			
   or  U1 (m, b, q);
   and U2 (q, m, a);
endmodule