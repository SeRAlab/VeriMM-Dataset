module top_module(out, a, b, sel);parameter n = 1;
   
   output [n-1:0] out;
   input [n-1:0]  a, b;
   input          sel;

   assign         out = sel == 1'b0 ? a : 
                        sel == 1'b1 ? b : 0 ;endmodule