module top_module(a, b, o);input [7:0] a;
   input [7:0] b;
   output [7:0] o;
   
   assign o = a ^ b;
endmodule