module top_module(a,b,s,c);input [31:0] a;
   input [31:0] b;
   output [31:0] s;
   output [31:0] c;

   assign s = a ^ b;
   assign c = a & b;

endmodule