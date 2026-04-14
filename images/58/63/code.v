module top_module(a,b,s,c);parameter width = 0;

   input [width-1:0] a;
   input [width-1:0] b;

   output [width-1:0] s;
   output [width-1:0] c;

   assign s = a ^ b;
   assign c = a & b;

endmodule