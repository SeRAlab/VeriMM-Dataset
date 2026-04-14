module top_module(sum, g, p, a, b, cin);output sum;
   output g;
   output p;
   input a;
   input b;
   input cin;

   xor x1(sum, a, b, cin);
   and a1(g, a, b);
   or  o1(p, a, b);
   
endmodule