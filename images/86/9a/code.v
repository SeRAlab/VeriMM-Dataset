module top_module(out, a, b, c, d, sel);parameter n = 1;
   
   output [n-1:0] out;
   input [n-1:0]  a, b, c, d;
   input [1:0]    sel;

   assign         out = sel == 2'b00 ? a : 
                        sel == 2'b01 ? b :
                        sel == 2'b10 ? c : 
                        sel == 2'b11 ? d : 0 ;endmodule